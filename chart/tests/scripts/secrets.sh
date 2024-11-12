#!/bin/bash
set -e


# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[0;33m'
CYN='\033[0;36m'
NC='\033[0m'

# KYVERNO_NAMESPACE should match with clone source in sync-secrets.yaml, in helm the env variable is passed: KYVERNO_NAMESPACE='{{ .Release.Namespace }}'
KYVERNO_NAMESPACE="kyverno-policies"
NAMESPACE="kyverno-bbtest"
SECRET_NAME="kyverno-bbtest-secret"
POLICY_NAME="sync-secrets"


#check for $KYVERNO_NAMESPACE
kubectl get namespace $KYVERNO_NAMESPACE 2> /dev/null || kubectl create namespace $KYVERNO_NAMESPACE

#ensure secret namespace does not already exist
kubectl get namespace $NAMESPACE 2> /dev/null && kubectl delete namespace $NAMESPACE 2> /dev/null

echo "Test: Copy secret to new namespace"
echo "Step 1: Create secret to be copied"

# kubectl create secret generic $SECRET_NAME -n $KYVERNO_NAMESPACE
kubectl get secret $SECRET_NAME -n $KYVERNO_NAMESPACE 2> /dev/null || kubectl create secret generic -n $KYVERNO_NAMESPACE $SECRET_NAME \
    --from-literal=username='username' \
    --from-literal=password='password'

#Double check if secret exists:
kubectl get secret $SECRET_NAME -n $KYVERNO_NAMESPACE

echo "Step 2: Apply kyverno policy"
# check for policy in /yaml which is located in ../manifests/
kubectl apply -n $KYVERNO_NAMESPACE -f - <<- EOF
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: $POLICY_NAME
  annotations:
    policies.kyverno.io/title: Sync Secrets
    policies.kyverno.io/category: Test
    policies.kyverno.io/subject: Secret
spec:
  rules:
  - name: sync-secret
    match:
      resources:
        kinds:
        - Namespace
        selector:
          matchLabels:
             kubernetes.io/metadata.name: "kyverno-bbtest"
    generate:
      apiVersion: v1
      kind: Secret
      name: kyverno-bbtest-secret
      namespace: "{{request.object.metadata.name}}"
      synchronize: true
      clone:
        namespace: $KYVERNO_NAMESPACE
        name: kyverno-bbtest-secret
EOF


# Check for ClusterPolicy secret-sync prior to creating the namespace

kubectl wait --timeout=60s --for='jsonpath={.status.conditions[?(@.type=="Ready")].status}=True' ClusterPolicy/$POLICY_NAME -n $NAMESPACE
if [ $? -eq 0 ]; then echo "$POLICY_NAME is ready"; fi

echo "Step 3: Check if the secret was created in new namespace"

kubectl create namespace $NAMESPACE && sleep 5 
kubectl wait --timeout=30s --for='jsonpath={.status.phase}="Active"' Namespace/$NAMESPACE

#wait 120s for secret
kubectl wait --timeout=120s --for='jsonpath={.kind}="Secret"' secret/$SECRET_NAME -n $NAMESPACE

# Timeout of 2 minutes in case we fail
timeout 120s /bin/sh -c "until kubectl get secret $SECRET_NAME -n $NAMESPACE; do sleep 5; done"
if [ $? -eq 0 ]; then echo "$SECRET_NAME succesfully created in $NAMESPACE"; fi

echo "Clean Up"
kubectl delete secret $SECRET_NAME -n $NAMESPACE 
kubectl delete ClusterPolicy $POLICY_NAME
kubectl delete secret $SECRET_NAME -n $KYVERNO_NAMESPACE
kubectl delete namespace $NAMESPACE --wait=false
echo -e "TEST: ${GRN}PASS${NC}"
