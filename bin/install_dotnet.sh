#!/bin/bash
# https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual
set -e
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
sudo chmod +x ./dotnet-install.sh
# install both net6 and net7
./dotnet-install.sh --channel 7.0
./dotnet-install.sh --channel 6.0
rm ./dotnet-install.sh
