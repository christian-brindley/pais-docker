FROM gcr.io/forgerock-io/java-25:latest

USER root

RUN apt-get update 
RUN apt-get install -y \
  vim \
  iproute2 \
  mkcert \
  unzip \
  gosu \
  sudo

ENV BASE_INSTALL_DIR /opt/ping
ENV TMP_DIR ${BASE_INSTALL_DIR}/tmp
ENV GATEWAY_INSTALL_DIR ${BASE_INSTALL_DIR}/gateway
ENV DS_INSTALL_DIR ${BASE_INSTALL_DIR}/ds
ENV PLATFORM_INSTALL_DIR ${BASE_INSTALL_DIR}/platform
ENV UI_INSTALL_DIR ${BASE_INSTALL_DIR}/ui

#
# Platform
#

RUN mkdir ${BASE_INSTALL_DIR} ${TMP_DIR}
RUN chown forgerock:root ${BASE_INSTALL_DIR}  ${TMP_DIR}


RUN echo "forgerock ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/forgerock

USER forgerock

COPY --chown=forgerock:root tools/docker-entrypoint.sh ${PLATFORM_INSTALL_DIR}/bin/docker-entrypoint.sh
RUN chmod 755 "${PLATFORM_INSTALL_DIR}/bin/docker-entrypoint.sh"

#
# Ping Gateway
#

COPY --chown=forgerock:root  dist/gateway ${TMP_DIR}
RUN unzip -q  ${TMP_DIR}/*.zip -d  ${TMP_DIR}/unpack \
    && mv  ${TMP_DIR}/unpack/* ${GATEWAY_INSTALL_DIR}/ \
    && rm -rf  ${TMP_DIR}/*

RUN CAROOT=${GATEWAY_INSTALL_DIR}/secrets/server-cert mkcert \
  -key-file ${GATEWAY_INSTALL_DIR}/secrets/server-cert/server.pem \
  -cert-file ${GATEWAY_INSTALL_DIR}/secrets/server-cert/server.pem \
  ais.local

COPY --chown=forgerock:root tools/gateway-config "${GATEWAY_INSTALL_DIR}/config"

#
# Platform UI
#

COPY --chown=forgerock:root  dist/ui ${TMP_DIR}
RUN unzip -q  ${TMP_DIR}/*.zip -d  ${TMP_DIR}/unpack \
    && mv  ${TMP_DIR}/unpack/* ${UI_INSTALL_DIR}/ \
    && rm -rf  ${TMP_DIR}/*


#
# Ping DS
#

COPY --chown=forgerock:root  dist/ds  ${TMP_DIR}
RUN unzip -q  ${TMP_DIR}/*.zip -d  ${TMP_DIR}/unpack \
    && mv  ${TMP_DIR}/unpack/* ${DS_INSTALL_DIR}/ \
    && rm -rf  ${TMP_DIR}/*

COPY --chown=forgerock:root  tools/setup-ds.sh ${TMP_DIR}/setup-ds.sh
RUN chmod 755 ${TMP_DIR}/setup-ds.sh \
    && ${TMP_DIR}/setup-ds.sh \
    && rm -rf  ${TMP_DIR}/*

ENTRYPOINT ["/bin/sh", "-c", "${PLATFORM_INSTALL_DIR}/bin/docker-entrypoint.sh"]






