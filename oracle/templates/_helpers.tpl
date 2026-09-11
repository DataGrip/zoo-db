{{/*
Expand the name of the chart.
*/}}
{{- define "oracle.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oracle.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oracle.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "oracle.labels" -}}
helm.sh/chart: {{ include "oracle.chart" . }}
{{ include "oracle.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "oracle.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oracle.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
PersistentVolumeClaim for one Oracle version, dynamically provisioned
(EKS has a default StorageClass, so no manual PersistentVolume is needed).
Usage: {{ include "oracle.pvc" (dict "root" . "version" "23m") }}
"version" must match both the values.yaml key suffix (oracle<version>) and the
values.yaml key must have a "persistence" block with size/storageClass.
Leave storageClass empty to use the cluster's default StorageClass.
Rendered PVC is named "<fullname>-<version>".
Gated on oracle<version>.persistence.enabled - each version opts in independently.
*/}}
{{- define "oracle.pvc" -}}
{{- $root := .root -}}
{{- $version := .version -}}
{{- $cfg := index $root.Values (printf "oracle%s" $version) -}}
{{- $p := $cfg.persistence | default dict -}}
{{- if $p.enabled }}
{{- $name := printf "%s-%s" (include "oracle.fullname" $root) $version }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ $name }}
  labels:
{{- include "oracle.labels" $root | nindent 4 }}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ $p.size | quote }}
  {{- if $p.storageClass }}
  storageClassName: {{ $p.storageClass | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Init container that wipes the persistent data volume before the main container
starts, so Oracle always creates the database from scratch (and re-runs the setup
scripts) instead of finding stale files left on the PVC from a previous run.
Usage: {{ include "oracle.pvcInitContainer" (dict "root" . "version" "23m") }}
Mounts the volume named "oracle-data" - pair with oracle.pvcVolumeMount/oracle.pvcVolume.
Gated on oracle<version>.persistence.enabled - each version opts in independently.
*/}}
{{- define "oracle.pvcInitContainer" -}}
{{- $root := .root -}}
{{- $version := .version -}}
{{- $cfg := index $root.Values (printf "oracle%s" $version) -}}
{{- $p := $cfg.persistence | default dict -}}
{{- if $p.enabled }}
- name: clean-data
  image: {{ $root.Values.cleanupImage | quote }}
  command:
  - sh
  - -c
  - rm -rf {{ $p.mountPath }}/*
  volumeMounts:
  - mountPath: {{ $p.mountPath }}
    name: oracle-data
{{- end }}
{{- end }}

{{/*
volumeMount entry for the main container to mount the persistent data volume.
Usage: {{ include "oracle.pvcVolumeMount" (dict "root" . "version" "23m") }}
Gated on oracle<version>.persistence.enabled - each version opts in independently.
*/}}
{{- define "oracle.pvcVolumeMount" -}}
{{- $root := .root -}}
{{- $version := .version -}}
{{- $cfg := index $root.Values (printf "oracle%s" $version) -}}
{{- $p := $cfg.persistence | default dict -}}
{{- if $p.enabled }}
- mountPath: {{ $p.mountPath }}
  name: oracle-data
{{- end }}
{{- end }}

{{/*
volumes entry binding the pod's "oracle-data" volume to the version's PVC
(see oracle.pvc for how that PVC is named/created).
Usage: {{ include "oracle.pvcVolume" (dict "root" . "version" "23m") }}
Gated on oracle<version>.persistence.enabled - each version opts in independently.
*/}}
{{- define "oracle.pvcVolume" -}}
{{- $root := .root -}}
{{- $version := .version -}}
{{- $cfg := index $root.Values (printf "oracle%s" $version) -}}
{{- $p := $cfg.persistence | default dict -}}
{{- if $p.enabled }}
- persistentVolumeClaim:
    claimName: {{ include "oracle.fullname" $root }}-{{ $version }}
  name: oracle-data
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "oracle.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "oracle.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
