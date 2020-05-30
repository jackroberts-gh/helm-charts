{{/*
Create helm partial for gitea server
*/}}
{{- define "init" }}
- name: init
  image: {{ .Values.images.gitea }}
  imagePullPolicy: {{ .Values.images.imagePullPolicy }}
  env:
  - name: POSTGRES_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ template "db.fullname" . }}
        key: dbPassword
  - name: SCRIPT
    value: &script |-
      mkdir -p /etc/gitea/conf
      if [ ! -f /etc/gitea/conf/app.ini ]; then
        echo "creating app.ini as one does not exist"
        cp /init/app.ini /etc/gitea/conf/app.ini
      fi
      chmod 777 /etc/gitea/conf/app.ini
      echo "chmod 777 app.ini"
  command: ["/bin/sh",'-c', *script]
  volumeMounts:
  - name: gitea-data
    mountPath: /etc/gitea
  - name: gitea-config-init
    mountPath: /init
{{- end }}