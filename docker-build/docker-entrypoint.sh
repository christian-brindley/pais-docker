#!/bin/sh

#
# Networking
#

# IP_DS=10.30.1.10
# IP_AM=10.30.1.20
# IP_IDM=10.30.1.30

# sudo ip addr add $IP_DS/32 dev lo
# sudo ip addr add $IP_AM/32 dev lo
# sudo ip addr add $IP_IDM/32 dev lo

#
# startup
#

/opt/ping/ds/bin/start-ds
/opt/ping/tomcat/bin/startup.sh
/opt/ping/gateway/bin/start.sh /opt/ping/gateway
