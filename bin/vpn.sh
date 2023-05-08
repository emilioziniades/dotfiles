#!/bin/bash

# A CLI tool for connecting to Fortinet VPN via SAML login. Has only 
# been tested on Pop!_OS, but should work for any Debian distribution.
#
# This tool makes heavy use of sudo, which is needed for openfortivpn 
# to do it's job. It also uses sudo to install dependencies. Vet this 
# script before blindly running on your machine.
#
# To install, run `./vpn.sh install`. Ensure that /usr/local/bin is in 
# your $PATH. If everything is working `vpn status` should return something 
# like "[DOWN]".
#
# You will need to create a configuration file at ~/.vpn. This is a JSON 
# array with "name", "host", "port" and "default" fields. An example 
# configuration file looks like this:
#
# [
#     {
#         "name": "favourite-vpn",
#         "host":  "one.vpn.com",
#         "port":  10443,
#         "default": true
#     },
#     {
#         "name": "less-favourite-vpn",
#         "host":  "two.vpn.com",
#         "port":  10443,
#         "default": false
#     }
# ]
#
# Then you can run `vpn up less-favourite-vpn` or `vpn up` to use the 
# default. To check the vpn status you can run `vpn status`, and to 
# disconnect from the vpn you can run `vpn down`. It's a little janky
# and you may need to press enter after running `vpn up` or `vpn down`.

set -e

VPN_CFG_FILE=~/.vpn
VPN_NAME_FILE=~/.vpn.current
VPN_PID=$(pgrep openfortivpn || true)

main() {
    if [[ ! -e $VPN_CFG_FILE ]]
    then
        echo "please create a configuration file at ~/.vpn with at least one default"
        exit 1
    fi

    case $1 in
        up)
            up $2;;
        down)
            down;;
        status)
            status;;
        logs)
            logs;;
        install)
            install;;
        *)
            echo "please specify a valid subcommand: up {vpn-name}, down, status, install"
    esac
}

up() {
    if [[ -z $VPN_PID ]]
    then
        if [[ -z $1 ]]
        then
            echo "connecting to default vpn"
            host=$(jq -e -c 'map(select(.default == true)) | "\(.[0].host):\(.[0].port)"' $VPN_CFG_FILE)
            name=$(jq -e -c 'map(select(.default == true)) | .[0].name' $VPN_CFG_FILE | tr -d '"')
        else
            host=$(jq -e -c "map(select(.name == \"$1\")) | \"\(.[0].host):\(.[0].port)\"" $VPN_CFG_FILE)
            name=$(jq -e -c "map(select(.name == \"$1\")) | .[0].name" $VPN_CFG_FILE | tr -d '"')
            if [[ $? == 1 ]]
            then
                echo "could not find host $1, check the ~/.vpn config file"
                exit 1
            fi
        fi
        echo "connecting to $name"
        echo $name > $VPN_NAME_FILE
        COOKIE=$(openfortivpn-webview $host)
        sudo -b openfortivpn --cookie=$COOKIE $host
    else
        echo "vpn already connected"
    fi
}

down() {
    if [[ -z $VPN_PID ]]
    then
        echo "vpn already down"
    else
        echo "stopping vpn"
        sudo kill $VPN_PID
        rm $VPN_NAME_FILE
    fi
}

status() {
    if [[ -z $VPN_PID ]]
    then
        echo "[DOWN]"
    else
        echo "[UP] [PID: $VPN_PID] [VPN: $(cat $VPN_NAME_FILE)]"
    fi
}

# we need to build from source because packages in apt are outdated :(
install() {

    echo "installing vpn"
    sudo apt install -y \
        jq \
        gcc \
        automake \
        autoconf \
        libssl-dev \
        make \
        pkg-config \
        qtcreator \
        qtbase5-dev \
        qt5-qmake \
        cmake \
        qtwebengine5-dev

    # install openfortivpn
    if ! command -v openfortivpn &> /dev/null
    then
        git clone https://github.com/adrienverge/openfortivpn
        cd openfortivpn
        git checkout v1.20.2
        ./autogen.sh
        ./configure --prefix=/usr/local --sysconfdir=/etc
        make
        sudo make install
        cd ..
        rm -rf ./openfortivpn
    fi

    # install openfortivpn-webview
    if ! command -v openfortivpn-webview &> /dev/null
    then
        git clone https://github.com/gm-vm/openfortivpn-webview
        cd openfortivpn-webview/openfortivpn-webview-qt
        git checkout v1.1.0-electron
        qmake .
        make
        sudo cp openfortivpn-webview /usr/local/bin
        cd ../..
        rm -rf ./openfortivpn-webview
    fi

    # install this script in path
    sudo cp ./vpn.sh /usr/local/bin/vpn

    echo "installation successful"
    echo "run \`vpn\` to ensure that the script exists and is on your path"
}

main $1 $2
