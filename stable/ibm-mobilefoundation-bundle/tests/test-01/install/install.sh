#!/bin/bash
#
# USER ACTION REQUIRED: This is a scaffold file intended for the user to modify
#
# Install script to install the operator
#
set -o errexit
set -o nounset
set -o pipefail

installDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "-------------------------- in install.sh"

echo "CV_TEST_INSTANCE_ADDR is "$CV_TEST_INSTANCE_ADDR

echo "kubectl get pods"
kubectl get pods

$APP_TEST_LIBRARY_FUNCTIONS/operatorInstall.sh \
	--cr $CV_TEST_BUNDLE_DIR/tests/test-01/install/charts_v1_mfoperator_cr.yaml

# oc patch mf/sample-mf -p '{"metadata":{"finalizers":[]}}' --type=merge
# kubectl patch crd/mfoperators.mf.ibm.com -p '{"metadata":{"finalizers":[]}}' --type=merge -n $CV_TEST_NAMESPACE