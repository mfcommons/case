#!/bin/bash
#
# USER ACTION REQUIRED: This is a scaffold file intended for the user to modify
#
# Delete script for resources tested
#
set -o errexit
set -o nounset
set -o pipefail

deleteDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$APP_TEST_LIBRARY_FUNCTIONS/operatorDelete.sh \
    --serviceaccount $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/service_account.yaml \
    --crd $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/crds/charts_v1_mfoperator_crd.yaml \
    --cr $CV_TEST_BUNDLE_DIR/tests/test-01/install/charts_v1_mfoperator_cr.yaml \
    --role $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/role.yaml \
    --rolebinding $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/role_binding.yaml \
    --operator $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/operator.yaml
    
    
echo "Deleting Policy : Cluster role to user"
oc adm policy remove-cluster-role-from-user cluster-admin system:serviceaccount:$CV_TEST_NAMESPACE:mf-operator

echo "--------------- in delete.sh"
echo "kubectl get all"
kubectl get all