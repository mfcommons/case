# ibm-mobilefoundation-helm-operator

This repository holds the code for the IBM Mobile Foundation (MF) operator that is based on the Helm Operator & helm charts from IBM Certified Containers Package for IBM Cloud Private (ICP).

**References:**

[ibm-mobilefoundation-containers](https://github.ibm.com/MobileFirst/ibm-mobilefoundation-containers)   
[ibm-mobilefoundation-prod](https://github.ibm.com/MobileFirst/ibm-mobilefoundation-prod)

**Note**: In the below document, wherever fields are referred between `<` and `>`, please replace these fields with applicable values in your configuration.

## Prerequisites

- An OpenShift 3.11 cluster
- Install OC Client tools to access the Openshift cluster. Refer [here](https://docs.openshift.com/container-platform/3.11/cli_reference/get_started_cli.html).
- Obtain the Mobile Foundation for Openshift package (tar.gz archive) from IBM Passport Advantage and unpack the archive to a directory, hereafter referred to as `<workdir>`.

	```bash
	tar xzvf IBM-MobileFoundation-Openshift-Pak-<version>.tar.gz -C <workdir>/
	```

- Mobile Foundation requires a database. Create a supported database and keep the database access details handy for further use. Refer [here] (https://mobilefirstplatform.ibmcloud.com/tutorials/ru/foundation/8.0/installation-configuration/production/prod-env/databases/)
- Mobile Foundation Analytics requires mounted storage volume for persisting Analytics data (NFS recommended).

## Setup the Openshift project for Mobile Foundation

- Login to the Openshift cluster and create a new project.

  ```bash
   export MFOS_PROJECT=<project-name>
   oc login -u <username> -p <password> <cluster-url>
   oc new-project $MFOS_PROJECT
  ```

- Load and push the images to Openshift registry from local.

  ```bash
	docker login -u <username> -p $(oc whoami -t) $(oc registry info)
	cd <workdir>/images
	ls * | xargs -I{} docker load --input {}
		
	for file in * ; do 
	  docker tag ${file/.tar.gz/} $(oc registry info)/$MFOS_PROJECT/${file/.tar.gz/}
	  docker push $(oc registry info)/$MFOS_PROJECT/${file/.tar.gz/}
	done
   ```

- Create a secret with credentials of the database.
  
	```bash
	cat <<EOF | oc apply -f -
	apiVersion: v1
	data:
		MFPF_ADMIN_DB_USERNAME: <base64-encoded-string>
		MFPF_ADMIN_DB_PASSWORD: <base64-encoded-string>
		MFPF_RUNTIME_DB_USERNAME: <base64-encoded-string>
		MFPF_RUNTIME_DB_PASSWORD: <base64-encoded-string>
		MFPF_PUSH_DB_USERNAME: <base64-encoded-string>
		MFPF_PUSH_DB_PASSWORD: <base64-encoded-string>
		MFPF_LIVEUPDATE_DB_USERNAME: <base64-encoded-string>
		MFPF_LIVEUPDATE_DB_PASSWORD: <base64-encoded-string>
		MFPF_APPCNTR_DB_USERNAME: <base64-encoded-string>
		MFPF_APPCNTR_DB_PASSWORD: <base64-encoded-string>
	kind: Secret
	metadata:
		name: mobilefoundation-db-secret
	type: Opaque
	EOF
	```

**NOTE:** An encoded string can be obtained using `echo -n <string-to-encode> | base64`.

- For Mobile Foundation Analytics, configure a persistent volume (PV).

	```bash
	cat <<EOF | oc apply -f -
	apiVersion: v1
	kind: PersistentVolume
	metadata:
	labels:
	name: mfanalyticspv
	name: mfanalyticspv
	spec:
	accessModes:
	- ReadWriteMany
	capacity:
	storage: 20Gi
	nfs:
	path: <nfs-mount-volume-path>
	server: <nfs-server-hostname-or-ip>
	EOF
	```

- For Mobile Foundation analytics, configure a persistent volume claim 

	```bash
	cat <<EOF | oc apply -f -
	apiVersion: v1
	kind: PersistentVolumeClaim
	metadata:
	name: mfanalyticsvolclaim
	namespace: <project-name-or-namespace>
	spec:
	accessModes:
	- ReadWriteMany
	resources:
		requests:
		storage: 20Gi
	selector:
		matchLabels:
		name: mfanalyticspv
	volumeName: mfanalyticspv
	status:
	accessModes:
	- ReadWriteMany
	capacity:
		storage: 20Gi
	EOF
	```

## Deploy the Mobile Foundation operator

1. Ensure the Operator image name (**mf-operator**) with tag is set for the operator in *deploy/operator.yaml*. placeholder: **REPO_URL**.

	```bash
	sed -i 's|REPO_URL|<image-repo-url>:<image-tag>|g' deploy/operator.yaml
	```
	
2. Ensure the namespace is set for the cluster role binding definition in *deploy/role_binding.yaml*. placeholder: **REPLACE_NAMESPACE**

	```bash
	sed -i 's|REPLACE_NAMESPACE|$MFOS_PROJECT|g' deploy/role_binding.yaml
	```
	
3. Run the below commands to deploy CRD, operator and install Security Context Constraints (SCC).

   ```bash
   oc create -f deploy/crds/charts_v1_mfoperator_crd.yaml
   oc create -f deploy/
   oc adm policy add-scc-to-group mf-operator system:serviceaccounts:$MFOS_PROJECT
   oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:$MFOS_PROJECT:mf-operator
   ```

## Deploy IBM Mobile Foundation components

To deploy any of the Mobile Foundation components, modify the custom resource configuration *deploy/crds/charts_v1_mfoperator_cr.yaml* according to your requirements. Complete reference to the custom configuration is found [here](cr-configuration.md)

```bash
oc apply -f deploy/crds/charts_v1_mfoperator_cr.yaml
```

Access the Mobile Foundation Server console from `https://<openshift-cluster-url>/mfpconsole`

## Cleanup

```bash
 oc delete -f deploy/crds/charts_v1_mfoperator_cr.yaml
 oc delete -f deploy/
 oc delete -f deploy/crds/charts_v1_mfoperator_crd.yaml
```
