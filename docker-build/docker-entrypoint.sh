#!/bin/sh

run_json() {
  local command="$1"
  local source="$2"
  shift 2

  "$command" "$@" 2>&1 |
    jq -R -c --arg source "$source" '
      . as $line
      | try (
          fromjson
          | if type == "object" then . + {source: $source}
            else {message: $line, source: $source}
            end
        )
        catch {message: $line, source: $source}
    '
}

run_json /opt/ping/ds/bin/start-ds ds --noDetach &
export CATALINA_OUT=/dev/stdout
run_json /opt/ping/tomcat/bin/startup.sh tomcat &
run_json /opt/ping/idm/startup.sh idm &
run_json /opt/ping/gateway/bin/start.sh gateway /opt/ping/gateway
