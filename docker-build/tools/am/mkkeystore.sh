# Script to create AM keystore
# v1

KEYSTORE_DIR="/opt/ping/am/security/keystores"
KEYSTORE_FILE="keystore.jceks"
STOREPASS_DIR="/opt/ping/am/security/secrets/default"
STOREPASS_FILE=".storepass"
KEYPASS_FILE=".keypass"
KEYSTORE_PASS="password"
KEYSTORE_TYPE="JCEKS"

DN_SUFFIX="DC=pais,DC=local"

keystore_path="${KEYSTORE_DIR}/${KEYSTORE_FILE}"
storepass_path="${STOREPASS_DIR}/${STOREPASS_FILE}"
keypass_path="${STOREPASS_DIR}/${KEYPASS_FILE}"

mkdir -p "$KEYSTORE_DIR" "$STOREPASS_DIR"

echo -n "$KEYSTORE_PASS" > "$storepass_path"
echo -n "$KEYSTORE_PASS" > "$keypass_path"


keytool -genkeypair -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias rsajwtsigningkey -keyalg RSA -keysize 2048 -sigalg SHA256WITHRSA -validity 3650 \
  -dname "CN=rsajwtsigningkey,$DN_SUFFIX"

keytool -genkeypair -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias rsa2048 -keyalg RSA -keysize 2048 -sigalg SHA256WITHRSA -validity 3650 \
  -dname "CN=rsa2048,$DN_SUFFIX"

keytool -genkeypair -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias es256 -keyalg EC -groupname secp256r1 -sigalg SHA256withECDSA -validity 3650 \
  -dname "CN=es256,$DN_SUFFIX"

keytool -genkeypair -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias es384 -keyalg EC -groupname secp384r1 -sigalg SHA256withECDSA -validity 3650 \
  -dname "CN=es384,$DN_SUFFIX"

keytool -genkeypair -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias es512 -keyalg EC -groupname secp521r1 -sigalg SHA256withECDSA -validity 3650 \
  -dname "CN=es512,$DN_SUFFIX"

keytool -genseckey -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias hmacsigning -keyalg HMacSHA512 -keysize 512

keytool -genseckey -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias directenc -keyalg aes -keysize 256

keytool -genseckey -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias selfservicesign -keyalg HMacSHA512 -keysize 256

keytool -genkeypair -keystore "$keystore_path" -storetype "$KEYSTORE_TYPE" \
  -keypass "$KEYSTORE_PASS" -storepass "$KEYSTORE_PASS" \
  -alias selfserviceenc -keyalg RSA -keysize 2048 -sigalg SHA256WITHRSA -validity 3650 \
  -dname "CN=selfserviceenc,$DN_SUFFIX"