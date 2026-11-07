#!/bin/sh

/opt/ping/ds/bin/start-ds
/opt/ping/tomcat/bin/startup.sh
nohup /opt/ping/idm/startup.sh > /opt/ping/idm/logs/console.out 2>&1 &
/opt/ping/gateway/bin/start.sh /opt/ping/gateway
