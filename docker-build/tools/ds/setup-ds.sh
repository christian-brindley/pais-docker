DEPLOYMENT_ID=AZWOfnIZ82vHgdX6FV7P73OaDa6utw5CBVN1bkVDAJ_1EX1U10cuithg
DEPLOYMENT_ID_PASSWORD=password

/opt/ping/ds/setup \
  --serverId ds \
  --deploymentId  "$DEPLOYMENT_ID" \
  --deploymentIdPassword "$DEPLOYMENT_ID_PASSWORD" \
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

/opt/ping/ds/bin/dskeymgr export-ca-cert \
  --deploymentId "$DEPLOYMENT_ID" \
  --deploymentIdPassword "$DEPLOYMENT_ID_PASSWORD" \
  --keyStoreFile /opt/ping/platform/am-truststore.p12 \
  --keyStorePassword "password" \
  --alias ds-ca-cert

# /opt/ping/ds/bin/dsconfig --offline \
#   set-connection-handler-prop \
#           --handler-name LDAPS \
#           --set 'listen-address:10.30.1.10' \
#           --no-prompt

# /opt/ping/ds/bin/dsconfig set-connection-handler-prop \
#           --handler-name LDAP \
#           --set 'enabled:false' \
#           --no-prompt


