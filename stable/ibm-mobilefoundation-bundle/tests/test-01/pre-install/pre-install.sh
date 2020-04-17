#!/bin/bash
#
# USER ACTION REQUIRED: This is a scaffold file intended for the user to modify
#
# Pre-install script REQUIRED ONLY IF additional setup is required prior to
# operator install for this test path.
#
# For example, if PersistantVolumes (PVs) are required
#
set -o errexit
set -o nounset
set -o pipefail

preinstallDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Verify pre-req environment
command -v kubectl > /dev/null 2>&1 || { echo "kubectl pre-req is missing."; exit 1; }

# Optional - set tool repo and source library for creating/configuring namespace
# NOTE: toolrepositoryroot needed for setting Policy Security Policy
. $APP_TEST_LIBRARY_FUNCTIONS/createNamespace.sh
toolrepositoryroot=$APP_TEST_LIBRARY_FUNCTIONS/../../

SECRET_NAME="cp.icr.io"

if [[ -z ${REPO_URL} ]];
then
    echo "variable named REPO_URL is not set"
    SECRET_NAME="cp.icr.io"
else
    echo "variable named REPO_URL is set"
    if [ "$TRAVIS_BRANCH" == "master" ]
    then 
        SECRET_NAME=$ER_PROD_HOST;
    else 
        echo "Replacing to staging registry in operator and custom resource yaml"
        sed -i 's|cp.icr.io|cp.stg.icr.io|g' $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/operator.yaml
        sed -i 's|cp.icr.io|cp.stg.icr.io|g' $CV_TEST_BUNDLE_DIR/tests/test-01/install/charts_v1_mfoperator_cr.yaml
        SECRET_NAME=$ER_STAGING_HOST;
    fi
    echo SECRET_NAME is $SECRET_NAME
fi

echo "Adding Policy : Cluster role to user"
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:$CV_TEST_NAMESPACE:mf-operator
echo "Replacing Placeholder : REPLACE_NAMESPACE"
sed -i 's|REPLACE_NAMESPACE|$CV_TEST_NAMESPACE|g' $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/role_binding.yaml

# create server login secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  MFPF_ADMIN_USER: YWRtaW4=
  MFPF_ADMIN_PASSWORD: YWRtaW4=
kind: Secret
metadata:
  name: serverlogin
type: Opaque
EOF

# create mfpserver secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  MFPF_ADMIN_DB_USERNAME: Ymx1YWRtaW4=
  MFPF_ADMIN_DB_PASSWORD: TkdJMk9ETTJaamhsWWpFMw==
  MFPF_RUNTIME_DB_USERNAME: Ymx1YWRtaW4=
  MFPF_RUNTIME_DB_PASSWORD: TkdJMk9ETTJaamhsWWpFMw==
  MFPF_PUSH_DB_USERNAME: Ymx1YWRtaW4=
  MFPF_PUSH_DB_PASSWORD: TkdJMk9ETTJaamhsWWpFMw==
  MFPF_LIVEUPDATE_DB_USERNAME: Ymx1YWRtaW4=
  MFPF_LIVEUPDATE_DB_PASSWORD: TkdJMk9ETTJaamhsWWpFMw==
kind: Secret
metadata:
  name: mfpserver-dbsecret
type: Opaque
EOF

# create mfpserver-dbadmin secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  MFPF_ADMIN_DB_ADMIN_USERNAME: Ymx1YWRtaW4=
  MFPF_ADMIN_DB_ADMIN_PASSWORD: TkdJMk9ETTJaamhsWWpFMw==
  MFPF_RUNTIME_DB_ADMIN_USERNAME: Ymx1YWRtaW4=
  MFPF_RUNTIME_DB_ADMIN_PASSWORD: TkdJMk9ETTJaamhsWWpFMw==
  MFPF_PUSH_DB_ADMIN_USERNAME: Ymx1YWRtaW4=
  MFPF_PUSH_DB_ADMIN_PASSWORD: TkdJMk9ETTJaamhsWWpFMw==
kind: Secret
metadata:
  name: mfpserver-dbadminsecret
type: Opaque
EOF

# create push confidential client secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  MFPF_PUSH_AUTH_CLIENTID: bWZwcHVzaA==
  MFPF_PUSH_AUTH_SECRET: aHN1cHBmbQ==
kind: Secret
metadata:
  name: mfppushconfclient-secret
type: Opaque
EOF

# create admin confidential client secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  MFPF_ADMIN_AUTH_CLIENTID: bWZwYWRtaW4=
  MFPF_ADMIN_AUTH_SECRET: bmltZGFwZm0=
kind: Secret
metadata:
  name: mfpadminconfclient-secret
type: Opaque
EOF

# create appcenter secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  MFPF_APPCNTR_DB_USERNAME: Ymx1YWRtaW4=
  MFPF_APPCNTR_DB_PASSWORD: TkdJMk9ETTJaamhsWWpFMw==
kind: Secret
metadata:
  name: appcenter-dbsecret
type: Opaque
EOF

# create appcenter login secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  MFPF_APPCNTR_ADMIN_USER: YWRtaW4=
  MFPF_APPCNTR_ADMIN_PASSWORD: YWRtaW4=
kind: Secret
metadata:
  name: appcntrlogin
type: Opaque
EOF

# create analytics login secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  MFPF_ANALYTICS_ADMIN_USER: YWRtaW4=
  MFPF_ANALYTICS_ADMIN_PASSWORD: YWRtaW4=
kind: Secret
metadata:
  name: analyticslogin
type: Opaque
EOF

# create analytics-receiver secret
cat <<EOF | kubectl apply -f - 
apiVersion: v1
kind: Secret
metadata:
  name: mfpanalytics-recvrsecret
type: Opaque
data:
  MFPF_ANALYTICS_RECVR_USER: YWRtaW4=
  MFPF_ANALYTICS_RECVR_PASSWORD: YWRtaW4=
EOF

$APP_TEST_LIBRARY_FUNCTIONS/operatorDeployment.sh \
    --crd $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/crds/charts_v1_mfoperator_crd.yaml \
    --serviceaccount $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/service_account.yaml \
    --role $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/role.yaml \
    --rolebinding $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/role_binding.yaml \
    --operator $CV_TEST_BUNDLE_DIR/operators/mf-operator/deploy/operator.yaml \
    --secretname $SECRET_NAME
#   --imagename FIXME
#   --secretname cp.stg.icr.io \  During development

# Optional setup for hardcoded namespace(s) with specific Pod Security Policy
# NOTE: clean-up.sh need to contain matching removeNamespace
# removeNamespace testopr ibm-privileged-psp || true
# configureNamespace testopr ibm-privileged-psp
