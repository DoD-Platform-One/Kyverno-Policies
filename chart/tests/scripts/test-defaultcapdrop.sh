#!/usr/bin/env bash
set -e

# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m'

POD_NAME=${POD_NAME:-"defaultcapdrop-container-test"}
NAMESPACE=${NAMESPACE:-"kyverno-policies-bbtest"}

echo "Step 1: Creating test pod $POD_NAME in namespace $NAMESPACE"

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: $POD_NAME
  namespace: $NAMESPACE
spec:
  initContainers:
  - name: ic1
    image: registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.30.6
    command: ["exit"]
  - name: ic2
    image: registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.30.6
    command: ["exit"]
    securityContext:
      capabilities:
        drop:
        - NET_RAW
  - name: ic3
    image: registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.30.6
    command: ["exit"]
    securityContext:
      capabilities:
        drop:
        - NET_RAW
        - ALL
  containers:
  - name: c1
    image: registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.30.6
    command: ["sleep","infinity"]
  - name: c2
    image: registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.30.6
    command: ["sleep","infinity"]
    securityContext:
      capabilities:
        drop:
        - NET_RAW
  - name: c3
    image: registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.30.6
    command: ["sleep","infinity"]
    securityContext:
      capabilities:
        drop:
        - NET_RAW
        - ALL
  imagePullSecrets:
  - name: private-registry
EOF

sleep 5s

echo "Step 2: Checking capability drops of pod"

ic1CapDrops=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.initContainers[0].securityContext.capabilities.drop}')
ic2CapDrops=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.initContainers[1].securityContext.capabilities.drop}')
ic3CapDrops=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.initContainers[2].securityContext.capabilities.drop}')
c1CapDrops=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop}')
c2CapDrops=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[1].securityContext.capabilities.drop}')
c3CapDrops=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[2].securityContext.capabilities.drop}')

cat <<EOF
Capability drops for initContainers:
  initContainers[0]: $ic1CapDrops
  initContainers[1]: $ic2CapDrops
  initContainers[2]: $ic3CapDrops

Capability drops for containers:
  containers[0]: $c1CapDrops
  containers[1]: $c2CapDrops
  containers[2]: $c3CapDrops
EOF

echo "Step 3: Cleanup - Deleting test pod $POD_NAME and $NAMESPACE"
kubectl delete pod "$POD_NAME" -n "$NAMESPACE"
kubectl delete namespace "$NAMESPACE"

echo "Security Context Test results:"

for capdrop in $ic1CapDrops $ic2CapDrops $ic3CapDrops $c1CapDrops $c2CapDrops $c3CapDrops; do
  if ! grep -q "ALL" <<<"$capdrop"; then
    echo "Default capability drop ALL was not added to all initContainers and containers"
    echo -e "TEST: ${RED}FAIL${NC}"
    exit 1
  fi
done

echo "Default capability drop ALL was added to all initContainers and containers"
echo -e "TEST: ${GRN}PASS${NC}"
