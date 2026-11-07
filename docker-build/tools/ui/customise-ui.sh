export AM_URL=https://pais.local/am
export AM_ADMIN_URL=https://pais.local/am/ui-admin
export IDM_REST_URL=https://pais.local/openidm
export IDM_ADMIN_URL=https://pais.local/admin
export IDM_UPLOAD_URL=https://pais.local/upload
export IDM_EXPORT_URL=https://pais.local/export
export MENUS_FILE=menus.platform
export ROUTES_FILE=routes.platform
export DEPLOYMENT_TYPE=PLATFORM
export ENABLE_WORKFORCE=false
export ENDUSER_UI_URL=https://pais.local/enduser/
export PLATFORM_ADMIN_URL=https://pais.local/platform/
export ENDUSER_CLIENT_ID=end-user-ui
export ADMIN_CLIENT_ID=idm-admin-ui
export THEME=default
export PLATFORM_UI_LOCALE=en

./variable_replacement.sh www/platform/js/*.js www/enduser/js/*.js www/login/js/*.js


