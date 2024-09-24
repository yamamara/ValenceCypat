#!/bin/bash

# Disable guest, root, nobody
sudo apt install lightdm -y
sudo sh -c 'echo "allow-guest=false" >> /etc/lightdm/lightdm.conf'
sudo sh -c 'echo "greeter-hide-users=true" >> /etc/lightdm/lightdm.conf'
sudo passwd -l root
sudo passwd -l nobody

# Password policy
sudo sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN 16/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 5/' /etc/login.defs
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 30/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE 24/' /etc/login.defs


# Change password of all users
new_password="NathanAreg@12345"
all_users=$(awk -F: '$1 != "nobody" && $1 != "'$(whoami)'" && $3 >= 1000 {print $1}' /etc/passwd)

for user in $all_users; do
    echo "Changing password for user: $user"
    echo "$user:$new_password" | sudo chpasswd
done

echo "Password change completed for all users except $(whoami)."

# Prompt the user to enter the list of users to keep
read -p "Enter the list of users to keep (space-separated): " users_to_keep
IFS=' ' read -ra keep_users <<< "$users_to_keep"

for user in $all_users; do
    if [[ " ${keep_users[@]} " =~ " ${user} " ]]; then
        echo "Keeping user: $user"
    else
        sudo deluser --remove-home "$user"
    fi
done

# Prompt the user to enter the list of proper administrators
read -p "Enter the list of proper administrators (comma-separated): " admins_input
IFS=',' read -ra admins <<< "$admins_input"

for user in $all_users; do
    if [[ " ${admins[@]} " =~ " ${user} " ]]; then
        sudo usermod -aG sudo "$user"
        echo "Granted administrator privileges to $user"
    else
        sudo deluser "$user" sudo
        echo "Revoked administrator privileges from $user"
    fi
done
