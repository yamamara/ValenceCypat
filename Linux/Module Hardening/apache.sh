#!/bin/bash

# Function for Ubuntu 22.04
ubuntuRun() {
    echo "Running Ubuntu-specific tasks..."


}

# Function for Mint 21
mintRun() {
    echo "Running Mint-specific tasks..."
    echo -e "\nKeepAlive On\nMaxKeepAliveRequests 100" | sudo tee -a /etc/apache2/apache2.conf
}

# Check the OS version
if [[ "$(lsb_release -is)" == "Ubuntu" && "$(lsb_release -rs)" == "22.04" ]]; then
    ubuntuRun
elif [[ "$(lsb_release -is)" == "LinuxMint" && "$(lsb_release -rs)" == "21" ]]; then
    mintRun
else
    echo "Unsupported OS version. This script only supports Ubuntu 22.04 or Mint 21."
fi
