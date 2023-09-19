{{/*
Compute the search URL

Usage: include "alfresco-content-service.search.url" $

*/}}
{{- define "alfresco-content-service.search.url" -}}
{{- with .Values }}
  {{- if or .search.url $.Values.global.elasticsearch.url }}
    {{- .search.url | default $.Values.global.elasticsearch.url }}
  {{- else if and (index . "alfresco-search-enterprise" "enabled")  (index . "alfresco-search-enterprise" "elasticsearch" "enabled") }}
    {{- with (index . "alfresco-search-enterprise") }}
      {{/* DRY needs a named template in subchart */}}
      {{- printf "%s://%s-%s:%s" .elasticsearch.protocol .elasticsearch.clusterName .elasticsearch.nodeGroup .elasticsearch.httpPort }}
    {{- end }}
  {{- else if (index . "alfresco-search" "enabled") }}
      {{/* DEPRECATE use chart.fullname with built ctx instead */}}
    {{- template "alfresco-search-service.fullname" . }}-solr
  {{- else }}
    {{- fail "You must either set search.url, alfresco-search-enterprise.enabled or alfresco-search.enabled" }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Compute the search "flavor"

Usage: include "alfresco-content-service.search.flavor" $

*/}}
{{- define "alfresco-content-service.search.flavor" -}}
{{- with .Values }}
  {{- if .search.flavor }}
    {{- .search.flavor }}
  {{- else if (index . "alfresco-search-enterprise" "enabled") }}
      {{- print "elasticsearch" }}
  {{- else if (index . "alfresco-search" "enabled") }}
      {{- print "solr6" }}
  {{- else }}
      {{- print "noindex" }}
  {{- end }}
{{- end }}
{{- end -}}
