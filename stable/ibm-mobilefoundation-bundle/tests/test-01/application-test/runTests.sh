#!/bin/bash

# Exit when failures occur (including unset variables)
set -o errexit
set -o nounset
set -o pipefail

# Verify pre-req environment
command -v kubectl > /dev/null 2>&1 || { echo "kubectl pre-req is missing."; exit 1; }

[[ `dirname $0 | cut -c1` = '/' ]] && appTestDir=`dirname $0`/ || appTestDir=`pwd`/`dirname $0`/

# Process parameters notify of any unexpected
while test $# -gt 0; do
#  [[ $1 =~ ^-e|--ipAddress$ ]] && { ipAddress="$2"; shift 2; continue; };
	[[ $1 =~ ^-c|--chartrelease$ ]] && { chartRelease="$2"; shift 2; continue; };
	echo "Parameter not recognized: $1, ignored"
	shift
done
: "${chartRelease:="default"}"
#: "${ipAddress:=""}"

# Setup and execute application test on installation
echo "Running application test"

echo "Testing the service availability"

# Get Ingress IP from Nodes using ExternalIP
HOST_IP=$(kubectl get nodes -l proxy=true -o json | jq -r '.items[0].status.addresses[] | select(.type == "ExternalIP") | .address')

if [ -z "${HOST_IP}" ]; then
   # Get Ingress IP from Nodes using InternalIP
   HOST_IP=$(kubectl get nodes -l proxy=true -o json | jq -r '.items[0].status.addresses[] | select(.type == "InternalIP") | .address')
fi
proxy_url=http://$HOST_IP
mfp_runtime_context=$proxy_url/mfp
printf "Runtime Endpoint URL is ${mfp_runtime_context}\n"
curl -k --connect-timeout 180 --output /dev/null --silent --head --fail $mfp_runtime_context
echo "SUCCESS - Mobile Foundation service availability passed."