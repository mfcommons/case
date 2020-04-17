#!/bin/bash
#
# USER ACTION REQUIRED: This is a scaffold file intended for the user to modify
#
# Post-install script REQUIRED ONLY IF additional setup is required post to
# operator install for this test path.
#
set -o errexit
set -o nounset
set -o pipefail

postInstallDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Verify pre-req environment
command -v kubectl > /dev/null 2>&1 || { echo "kubectl pre-req is missing."; exit 1; }

echo "-------------------------- in post-install.sh"

echo "Replacing $CV_TEST_NAMESPACE to placeholder REPLACE_NAMESPACE"
sed -i 's|$CV_TEST_NAMESPACE|REPLACE_NAMESPACE|g' $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/role_binding.yaml

echo "kubectl get pods"
kubectl get pods
operator_pod=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep mf-operator)
echo "+++++++++++++++++OPERATOR POD: "$operator_pod
kubectl logs $operator_pod