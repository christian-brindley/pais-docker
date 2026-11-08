#!/bin/sh
# Emulate the PingOne Advanced Identity Cloud (AIC) admin/enduser/login UIs.

FQDN=${IAM_FQDN:-pais.local}   # must match the mkcert cert + gateway Host rewrites (pais.local today)

# --- The AIC switch ---------------------------------------------------------
export PLATFORM_UI_IS_FRAAS=true     # drives isFraas, idcloud menus/routes defaults,
                                     # enables governance flags, tenant branding
export DEPLOYMENT_TYPE=PLATFORM      # enum here is {PLATFORM, IDM}; no CLOUD value exists
export MENUS_FILE=menus.idcloud      # AIC admin console menu (Dashboard, Applications, Journeys, ...)
export ROUTES_FILE=routes.idcloud

# --- Tenant URLs (single public host, gateway-fronted, like an AIC tenant) ---
export AM_URL=https://${FQDN}/am
export AM_ADMIN_URL=https://${FQDN}/am/ui-admin     # AIC "Native console" link
export IDM_REST_URL=https://${FQDN}/openidm
export IDM_ADMIN_URL=https://${FQDN}/admin
export IDM_UPLOAD_URL=https://${FQDN}/upload
export IDM_EXPORT_URL=https://${FQDN}/export
export ENDUSER_UI_URL=https://${FQDN}/enduser/
export PLATFORM_ADMIN_URL=https://${FQDN}/platform/

# --- AIC is CIAM: no workforce suite, no IGA unless you want to demo it ------
export ENABLE_WORKFORCE=false
export ENABLE_GOVERNANCE=false      # only honored when FRAAS=true; flip to demo IGA menu

# AIC lands admins in the alpha realm
export FRAAS_DEFAULT_REALM=alpha

export ENDUSER_CLIENT_ID=end-user-ui
export ADMIN_CLIENT_ID=idm-admin-ui
export THEME=default
export PLATFORM_UI_LOCALE=en

./variable_replacement.sh www/platform/js/*.js www/enduser/js/*.js www/login/js/*.js