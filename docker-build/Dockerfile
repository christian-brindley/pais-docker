FROM gcr.io/forgerock-io/java-25:latest

USER root

RUN apt-get update 
RUN apt-get install -y \
  vim \
  iproute2 \
  mkcert \
  unzip \
  gosu \
  sudo \
  gettext-base \
  git \
  rsync

ENV BASE_INSTALL_DIR /opt/ping
ENV TMP_DIR ${BASE_INSTALL_DIR}/tmp
ENV GATEWAY_INSTALL_DIR ${BASE_INSTALL_DIR}/gateway
ENV DS_INSTALL_DIR ${BASE_INSTALL_DIR}/ds
ENV PLATFORM_INSTALL_DIR ${BASE_INSTALL_DIR}/platform
ENV UI_INSTALL_DIR ${BASE_INSTALL_DIR}/ui
ENV TOMCAT_INSTALL_DIR ${BASE_INSTALL_DIR}/tomcat
ENV IDM_INSTALL_DIR ${BASE_INSTALL_DIR}/idm
ENV AM_INSTALL_DIR ${BASE_INSTALL_DIR}/am

#
# Platform
#

RUN mkdir ${BASE_INSTALL_DIR} ${TMP_DIR}
RUN chown forgerock:root ${BASE_INSTALL_DIR}  ${TMP_DIR}

RUN echo "forgerock ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/forgerock

USER forgerock

COPY --chown=forgerock:root docker-entrypoint.sh ${PLATFORM_INSTALL_DIR}/bin/docker-entrypoint.sh
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
  pais.local

COPY --chown=forgerock:root tools/gateway/gateway-config "${GATEWAY_INSTALL_DIR}/config"

#
# Platform UI
#

# COPY --chown=forgerock:root  dist/idm-ui ${TMP_DIR}
# RUN unzip -q  ${TMP_DIR}/*.zip -d  ${TMP_DIR}/unpack \
#     && mv  ${TMP_DIR}/unpack/* ${UI_INSTALL_DIR}/ \
#     && rm -rf  ${TMP_DIR}/*

COPY --chown=forgerock:root  dist/ui ${TMP_DIR}
RUN unzip -q  ${TMP_DIR}/*.zip -d  ${TMP_DIR}/unpack \
    && mv  ${TMP_DIR}/unpack/* ${UI_INSTALL_DIR}/ \
    && rm -rf  ${TMP_DIR}/*

COPY --chown=forgerock:root  tools/ui/customise-ui.sh ${UI_INSTALL_DIR}/customise-ui.sh
RUN chmod 755 ${UI_INSTALL_DIR}/customise-ui.sh ${UI_INSTALL_DIR}/variable_replacement.sh \
    && cd ${UI_INSTALL_DIR} \
    && ./customise-ui.sh 

#
# Ping DS
#

COPY --chown=forgerock:root  dist/ds  ${TMP_DIR}
RUN unzip -q  ${TMP_DIR}/*.zip -d  ${TMP_DIR}/unpack \
    && mv  ${TMP_DIR}/unpack/* ${DS_INSTALL_DIR}/ \
    && rm -rf  ${TMP_DIR}/*

COPY --chown=forgerock:root tools/ds/setup-profiles/PAIS ${DS_INSTALL_DIR}/template/setup-profiles/PAIS

COPY --chown=forgerock:root  tools/ds/setup-ds.sh ${TMP_DIR}/setup-ds.sh
COPY --chown=forgerock:root  tools/ds/applications.ldif ${TMP_DIR}/applications.ldif
RUN chmod 755 ${TMP_DIR}/setup-ds.sh \
    && ${TMP_DIR}/setup-ds.sh ${TMP_DIR}/applications.ldif \
    && rm -rf  ${TMP_DIR}/*

#
# Ping AM
#

COPY --chown=forgerock:root  dist/tomcat  ${TMP_DIR}
RUN unzip -q  ${TMP_DIR}/*.zip -d  ${TMP_DIR}/unpack \
    && mv  ${TMP_DIR}/unpack/* ${TOMCAT_INSTALL_DIR}/ \
    && rm -rf  ${TMP_DIR}/*

COPY --chown=forgerock:root  dist/am  ${TMP_DIR}
RUN mkdir -p ${TOMCAT_INSTALL_DIR}/webapps/am \
    && cd ${TOMCAT_INSTALL_DIR}/webapps/am  \
    && jar -xf ${TMP_DIR}/*.war \
    && rm -rf  ${TMP_DIR}/*

COPY --chown=forgerock:root tools/am/setenv.sh ${TOMCAT_INSTALL_DIR}/bin/setenv.sh
RUN chmod 755 ${TOMCAT_INSTALL_DIR}/bin/*

COPY --chown=forgerock:root  tools/am/mkkeystore.sh ${TMP_DIR}/mkkeystore.sh
RUN chmod 755 ${TMP_DIR}/mkkeystore.sh \
    && ${TMP_DIR}/mkkeystore.sh \
    && rm -rf  ${TMP_DIR}/*

COPY --chown=forgerock:root  tools/am/am-config.zip  ${TMP_DIR}
RUN mkdir -p ${AM_INSTALL_DIR} \
    && cd ${AM_INSTALL_DIR}  \
    && unzip  ${TMP_DIR}/am-config.zip \
    && rm -rf  ${TMP_DIR}/*

#
# Ping IDM
#

COPY --chown=forgerock:root  dist/idm  ${TMP_DIR}
RUN unzip -q  ${TMP_DIR}/*.zip -d  ${TMP_DIR}/unpack \
    && mv  ${TMP_DIR}/unpack/* ${IDM_INSTALL_DIR}/ \
    && rm -rf  ${TMP_DIR}/*

COPY --chown=forgerock:root  tools/idm/authentication.json  ${IDM_INSTALL_DIR}/conf/authentication.json
COPY --chown=forgerock:root  tools/idm/repo.ds.json  ${IDM_INSTALL_DIR}/conf/repo.ds.json
COPY --chown=forgerock:root  tools/idm/managed.json  ${IDM_INSTALL_DIR}/conf/managed.json
COPY --chown=forgerock:root  tools/idm/boot.properties  ${IDM_INSTALL_DIR}/resolver/boot.properties


ENTRYPOINT ["/bin/sh", "-c", "${PLATFORM_INSTALL_DIR}/bin/docker-entrypoint.sh"]


