#!/bin/bash
#This file is installed in /etc/profile.d and will allow shell users to use calaos tools directly

# calaos_ddns
export CALAOS_HAPROXY_PATH="/mnt/calaos/haproxy"
export CALAOS_CERT_FILE="CALAOS_CERT_FILE=/mnt/calaos/haproxy/server.pem"
export CALAOS_CONFIG="/mnt/calaos/config"
export CALAOS_HAPROXY_TEMPLATE_PATH="/usr/share/calaos-ddns"

alias calaos_config='podman exec calaos-server /opt/bin/calaos_config'
alias calaos_1wire='podman exec calaos-server /opt/bin/calaos_1wire'
alias wago_test='podman exec calaos-server /opt/bin/wago_test'
alias calaos_mail='podman exec calaos-server /opt/bin/calaos_mail'
