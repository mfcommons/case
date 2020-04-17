FROM quay.io/operator-framework/helm-operator:v0.9.0

LABEL name="mf-operator" \
	vendor="IBM" \
	version="1.0.15" \
	release="1" \
	summary="IBM Mobile Foundation Operator" \
	description="IBM Mobile Foundation Operator" \
	io.k8s.description="IBM Mobile Foundation Operator" \
    io.k8s.display-name="IBM Mobile Foundation Operator" \
    io.openshift.tags="mobilefoundation, mf"

USER root
RUN microdnf update -y

USER 1001

COPY licenses /licenses

COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts/ ${HOME}/helm-charts/
