/opt/ping/ds/setup \
  --serverId ds \
  --deploymentId AZWOfnIZ82vHgdX6FV7P73OaDa6utw5CBVN1bkVDAJ_1EX1U10cuithg \
  --deploymentIdPassword password \
  --rootUserDN "uid=admin" \
  --rootUserPassword password \
  --monitorUserPassword password \
  --hostname ds \
  --adminConnectorPort 4444 \
  --ldapPort 1389 \
  --enableStartTls \
  --ldapsPort 1636 \
  --profile am-config \
  --set "am-config/amConfigAdminPassword:password" \
  --profile am-cts \
  --set "am-cts/amCtsAdminPassword:password" \
  --profile am-identity-store \
  --set "am-identity-store/amIdentityStoreAdminPassword:password" \
  --acceptLicense

/opt/ping/ds/bin/dsconfig --offline \
  set-connection-handler-prop \
          --handler-name LDAPS \
          --set 'listen-address:10.30.1.10' \
          --no-prompt
