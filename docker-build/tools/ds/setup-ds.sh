DEPLOYMENT_ID=AZWOfnIZ82vHgdX6FV7P73OaDa6utw5CBVN1bkVDAJ_1EX1U10cuithg
DEPLOYMENT_ID_PASSWORD=password
KEYSTORE_DIRECTORY=/opt/ping/platform/security/truststores


APPLICATIONS_LDIF=$1

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
  --profile pais-config \
  --set "pais-config/amConfigAdminPassword:password" \
  --set "pais-config/idmRsClientSecret:password" \
  --profile am-cts \
  --set "am-cts/amCtsAdminPassword:password" \
  --profile am-identity-store \
  --set "am-identity-store/amIdentityStoreAdminPassword:password" \
  --profile idm-repo \
  --set idm-repo/domain:forgerock.io \
  --acceptLicense 

mkdir -p ${KEYSTORE_DIRECTORY}

/opt/ping/ds/bin/dskeymgr export-ca-cert \
  --deploymentId "$DEPLOYMENT_ID" \
  --deploymentIdPassword "$DEPLOYMENT_ID_PASSWORD" \
  --keyStoreFile ${KEYSTORE_DIRECTORY}/truststore.p12 \
  --keyStorePassword "password" \
  --alias ds-ca-cert

echo -n password > ${KEYSTORE_DIRECTORY}/truststore.password



