# Tekton-Pipelines

Tekton is a Kubernetes-native, continuous integration and delivery (CI/CD) framework that enables you to create containerized, composable, and configurable workloads declaratively through CRDs

These pipelines can be used for mobile app registration, build and app center publish.

## Creation of the Tasks and Pipeline for Application Registration

oc apply -f pipeline/mobile-app-registration -n "projectname"

## Creation of the Tasks and Pipeline for App Build

oc apply -f pipeline/mobile-app-build-android -n "projectname"

oc apply -f pipeline/mobile-app-build-ios -n "projectname"

## Creation of the Tasks and Pipeline for Publishing the apk or ipa file to the Application Center

oc apply -f pipeline/mobile-app-publish -n "projectname"