#!/bin/bash

sudo apt-get update -y

all_services=$(systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}')
necessary_services=(
    "accounts-daemon.service"
    "acpid.service"
    "ccsclient.service"
    "cron.service"
    "dbus.service"
    "gdm.service"
    "networkd-dispatcher.service"
    "NetworkManager.service"
    "open-vm-tools.service"
    "polkit.service"
    "rsyslog.service"
    "ssh.service"
    "systemd-oomd.service "
    "systemd-journald.service"
    "systemd-logind.service"
    "systemd-networkd.service"
    "systemd-resolved.service"
    "systemd-timesyncd.service"
    "systemd-udevd.service"
    "udisks2.service"
    "upower.service"
    "vgauth.service"
    "wpa_supplicant.service"
)


for service in $all_services; do
    if [[ " ${necessary_services[@]} " =~ " ${service} " ]]; then
        echo "Skipping necessary service: $service"
    else
        read -p "Do you want to stop and disable $service? (y/n): " answer
        if [[ "$answer" == "y" ]]; then
            sudo systemctl stop "$service"
            sudo systemctl disable "$service"
        else
            echo "Skipped $service."
        fi
    fi
done

packages_to_remove=(
  "thunderbird"
  "aisleriot"
  "gnome-mahjongg"
  "gnome-mines"
  "gnome-sudoku"
  "cheese"
  "shotwell"
  "rhythmbox"
  "totem"
  "transmission-common"
  "brasero"
  "simple-scan"
)


echo "Updating package list..."
sudo apt-get update -y

echo "Removing unnecessary packages..."
for package in "${packages_to_remove[@]}"
do
  if dpkg -l | grep -q "^ii  $package"; then
    echo "Removing $package..."
    sudo apt-get purge -y "$package" > /dev/null 2>&1
  else
    echo "$package is not installed or already removed."
  fi
done

echo "Cleaning up..."
sudo apt-get autoremove -y > /dev/null 2>&1
sudo apt-get clean > /dev/null 2>&1

programs=("7zip")

for program in "${programs[@]}"; do
    echo "Do you want to remove $program? (Y/N)"
    read -r choice

    if [[ "$choice" == [Yy] ]]; then
        echo "Removing $program..."
        sudo apt-get remove --purge "$program" -y
        echo "$program removed."
    else
        echo "Skipping $program removal."
    fi

    echo
done

sudo apt-get autoremove -y
sudo apt-get clean
echo "All selected programs removed."
