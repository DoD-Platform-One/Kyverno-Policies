#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[0;33m'
CYN='\033[0;36m'
NC='\033[0m'

POD_NAME="ephemeral-container-test"
NAMESPACE="kyverno-policies-bbtest"

kubectl get namespace $NAMESPACE 2> /dev/null || kubectl create namespace $NAMESPACE

echo "Step 1: Creating test pod $POD_NAME"
kubectl apply -f - <<- EOF
apiVersion: v1
kind: Pod
metadata:
  name: $POD_NAME
  namespace: $NAMESPACE
spec:
  containers:
  - name: c1
    image: registry1.dso.mil/ironbank/redhat/ubi/ubi9-minimal:latest-amd64
    args: ["sleep","infinity"]
    securityContext:
      capabilities:
        drop:
        - ALL
  imagePullSecrets:
  - name: private-registry
EOF


echo "Step 2: Waiting for creation of $POD_NAME"
sleep 10s

set +e
echo "Step 3: Executing Command: 'kubectl debug $POD_NAME -it --image=busybox'"
result=$(timeout 10 kubectl debug $POD_NAME -it --image=busybox -n $NAMESPACE 2>&1)

echo "output from command:"
echo $result

result=$(echo $result | grep -oP "rule block-ephemeral-containers failed" | grep -oP failed)

set -e
echo "Step 4: Cleanup - Deleting test pod $POD_NAME and $NAMESPACE"
kubectl delete pod $POD_NAME -n $NAMESPACE
kubectl delete namespace $NAMESPACE --wait=false

echo "Step 5: Block Emphemeral container Test Results:"

if [ "$result" == "failed" ]; then
  echo "ephemeral container creation was sucessfully blocked"
  echo -e "TEST: ${GRN}PASS${NC}"
else
  echo "ephemeral container creation was not blocked"
  echo -e "TEST: ${RED}FAIL${NC}"
  exit 1
fi
