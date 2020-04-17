#!/bin/bash
#
# USER ACTION REQUIRED: This is a scaffold file intended for the user to modify
#
# Test script REQUIRED to test your operator
#
set -o errexit
set -o nounset
set -o pipefail

testDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "--------------------- in test.sh"
echo "kubectl get pods"
kubectl get pods
sleep 90
echo "-------------------- pods in running state"
oc get pods | grep mf | grep Running