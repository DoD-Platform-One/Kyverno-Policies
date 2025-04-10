#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[0;33m'
CYN='\033[0;36m'
NC='\033[0m'

POD_NAME="defaultsecuritycontext-container-test"
NAMESPACE="kyverno-policies-bbtest"

echo "Step 1: Creating test pod $POD_NAME in namespace $NAMESPACE"

kubectl get namespace $NAMESPACE 2> /dev/null || kubectl create namespace $NAMESPACE

kubectl apply -f - <<- EOF
apiVersion: v1
kind: Pod
metadata:
  name: $POD_NAME
  namespace: $NAMESPACE
spec:
  containers:
  - name: c1
    image: registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.32.3
    command: ["sleep","infinity"]
    securityContext:
      capabilities:
        drop:
        - ALL
  imagePullSecrets:
  - name: private-registry
EOF

sleep 5s

echo "Step 2: Checking securitycontext of pod"

podsecurityContext=$(kubectl get pod $POD_NAME -n $NAMESPACE -o 'jsonpath={.spec.securityContext}')
echo "PODSECURITYCONTEXT: $podsecurityContext"
policysecuritycontext='{"fsGroup":65534,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534}'


echo "Step 3: Cleanup - Deleting test pod $POD_NAME and $NAMESPACE"
kubectl delete pod $POD_NAME -n $NAMESPACE
kubectl delete namespace $NAMESPACE

echo "Security Context Test results:"

if [[ "$podsecurityContext" == "$policysecuritycontext" ]]; then 
  echo "Defaultsecuritycontext successfully added"
  echo -e "TEST: ${GRN}PASS${NC}"
else 
  echo "Defaultsecuritycontext missing"
  echo -e "TEST: ${RED}FAIL${NC}"
  exit 1
fi
