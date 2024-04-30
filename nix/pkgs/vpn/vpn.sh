#!/usr/bin/env bash

# A CLI tool for connecting to Fortinet VPN via SAML login.
#
# Essentially a script to glue [`openfortivpn`](https://github.com/adrienverge/openfortivpn)
# and [`openfortivpn-webview`](https://github.com/gm-vm/openfortivpn-webview) together.
#
# This tool makes heavy use of sudo, which is needed for openfortivpn
# to do it's job. Vet this script (and it's dependencies) before running
# on your machine.
#
# You will need to create a configuration file at ~/.vpn OR a location specified by the $VPN_CONFIG_FILE
# environment variable. This is a JSON array with "name", "host", "port" and "default" fields.
# An example configuration file looks like this:
#
# [
#     {
#         "name": "favourite-vpn",
#         "host":  "one.vpn.com",
#         "port":  1234,
#         "default": true
#     },
#     {
#         "name": "less-favourite-vpn",
#         "host":  "two.vpn.com",
#         "port":  1234,
#         "default": false
#     }
# ]
#
# Then you can run `vpn less-favourite-vpn` or `vpn` to use the
# default.
#
# It is possible to setup this script to run as a systemd service,
# but I usually just run the script, hit ctrl-z and then the `bg` command.
set -e

CONFIG=${VPN_CONFIG_FILE:-~/.vpn}
VPN_PID=$(pgrep openfortivpn || true)

if [[ ! -e $CONFIG ]]; then
	echo "please create a configuration file at ~/.vpn with at least one default"
	exit 1
fi

echo "using configuration file at $CONFIG"

if [[ -n $VPN_PID ]]; then
	echo "vpn already connected"
	exit 1
fi

if [[ -z $1 ]]; then
	filter="map(select(.default == true))"
else
	filter="map(select(.name == \"$1\"))"
fi

host=$(jq -e -c "$filter | \"\(.[0].host):\(.[0].port)\"" $CONFIG | tr -d '"')
name=$(jq -e -c "$filter | .[0].name" $CONFIG | tr -d '"')

if [[ $? == 1 ]]; then
	echo "could not find host $1, check the ~/.vpn config file"
	exit 1
fi

echo "connecting to $name"
COOKIE=$(openfortivpn-webview $host)
sudo --preserve-env=PATH env openfortivpn --cookie=$COOKIE $host
