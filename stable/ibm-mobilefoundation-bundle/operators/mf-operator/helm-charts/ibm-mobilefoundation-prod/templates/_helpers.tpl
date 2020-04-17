{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ibm-mobilefoundation.productName" -}}
"IBM MobileFirst Platform Foundation"
{{- end -}}

{{- define "ibm-mobilefoundation.productID" -}}
"9380ea99ddde4f5f953cf773ce8e57fc"
{{- end -}}

{{- define "ibm-mobilefoundation.productVersion" -}}
"8.0"
{{- end -}}

{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trimSuffix "-" -}}
{{- end -}}

{{- define "k8name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s_%s" .Release.Name $name | trimSuffix "-" | replace "-" "_" | upper -}}
{{- end -}}

{{- define "mfp.ingress.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfp-ingress" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.server.fullname" -}}
{{- printf "%9.9s-%s" .Release.Name "mfpserver" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.push.fullname" -}}
{{- printf "%9.9s-%s" .Release.Name "mfppush" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.liveupdate.fullname" -}}
{{- printf "%9.9s-%s" .Release.Name "mfpliveupdate" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.analytics.fullname" -}}
{{- printf "%9.9s-%s" .Release.Name "mfpanalytics" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.analytics-recvr.fullname" -}}
{{- printf "%9.9s-%s" .Release.Name "mfpanalytics-recvr" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.appcenter.fullname" -}}
{{- printf "%9.9s-%s" .Release.Name "mfpappcenter" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.dbinit.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpdbinit" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.server-configmap.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpserver-configmap" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.push-configmap.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfppush-configmap" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.liveupdate-configmap.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpliveupdate-configmap" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.analytics-configmap.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpanalytics-configmap" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.appcenter-configmap.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpappcenter-configmap" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.push-client-secret.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfppushclientsecret" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.liveupdate-client-secret.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpliveupdateclientsecret" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.server-admin-client-secret.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpserveradminclientsecret" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.analytics-recvr-secret.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpanalytics-recvrsecret" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.server-console-secret.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpserverconsolesecret" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.analytics-console-secret.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpanalyticsconsolesecret" | trimSuffix "-" -}}
{{- end -}}

{{- define "mfp.appcenter-console-secret.fullname" -}}
{{- printf "%s-%s" .Release.Name "mfpappcenterconsolesecret" | trimSuffix "-" -}}
{{- end -}}
