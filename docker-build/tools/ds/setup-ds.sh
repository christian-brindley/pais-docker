DEPLOYMENT_ID=AZWOfnIZ82vHgdX6FV7P73OaDa6utw5CBVN1bkVDAJ_1EX1U10cuithg
DEPLOYMENT_ID_PASSWORD=password
KEYSTORE_DIRECTORY=/opt/ping/platform/security/truststores
BASE_INSTALL_DIR=/opt/ping
DS_INSTALL_DIR=$BASE_INSTALL_DIR/ds

$DS_INSTALL_DIR/setup \
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
  --profile pais-identity-store \
  --set "pais-identity-store/amIdentityStoreAdminPassword:password" \
  --profile idm-repo \
  --set idm-repo/domain:forgerock.io \
  --acceptLicense 

$DS_INSTALL_DIR/bin/dsconfig create-log-publisher \
  --type console-error \
  --publisher-name "Console Error Logger" \
  --set enabled:true \
  --set default-severity:info \
  --set json-output:true \
  --offline \
  --no-prompt


for logpublisher in \
  "File-Based Access Logger" \
  "File-Based Audit Logger" \
  "File-Based Error Logger" \
  "File-Based HTTP Access Logger" \
  "Filtered Json File-Based Access Logger" \
  "Json File-Based Access Logger" \
  "Json File-Based HTTP Access Logger"
do
  $DS_INSTALL_DIR/bin/dsconfig delete-log-publisher \
          --publisher-name "$logpublisher" \
          --offline \
          --no-prompt
done

$DS_INSTALL_DIR/bin/dsconfig create-log-publisher \
  --publisher-name "Console LDAP Access Logger" \
  --type external-access \
  --set enabled:true \
  --set config-file:config/audit-handlers/ldap-access-stdout.json \
  --offline \
  --no-prompt

$DS_INSTALL_DIR/bin/dsconfig create-log-publisher \
  --publisher-name "Console HTTP Access Logger" \
  --type external-http-access \
  --set enabled:true \
  --set config-file:config/audit-handlers/http-access-stdout.json \
  --offline \
  --no-prompt

mkdir -p ${KEYSTORE_DIRECTORY}

/opt/ping/ds/bin/dskeymgr export-ca-cert \
  --deploymentId "$DEPLOYMENT_ID" \
  --deploymentIdPassword "$DEPLOYMENT_ID_PASSWORD" \
  --keyStoreFile ${KEYSTORE_DIRECTORY}/truststore.p12 \
  --keyStorePassword "password" \
  --alias ds-ca-cert

echo -n password > ${KEYSTORE_DIRECTORY}/truststore.password



