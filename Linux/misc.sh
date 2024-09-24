#!/bin/bash

# Update the package lists
sudo apt-get update


# Enable UFW
sudo apt-get install ufw -y
sudo ufw enable
echo "UFW has been enabled."


# Enable auto-updates
apt-get update
apt-get install -y unattended-upgrades

echo 'APT::Periodic::Update-Package-Lists "1";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic

echo "Automatic updates have been enabled. Configuration files updated."


# Perform the system upgrade
sudo apt-get upgrade -y
echo "Debian update has been triggered."

# Disabling running scripts with root
echo "ALL ALL=(ALL:ALL) !/bin/bash /path/to/your_script.sh" | tee -a /etc/sudoers
echo "Script execution with root access has been disabled."


# Backup SSHd configuration file
sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.bak

# Disable root login via SSH
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/ssh_config

# Restart SSH service
sudo systemctl restart ssh

sshd_config="/etc/ssh/ssh_config"
cp "$sshd_config" "$sshd_config.bak"
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' "$sshd_config"

systemctl restart ssh

echo "OpenSSH root login has been disabled. Original configuration backed up to $sshd_config.bak."

# W bin laden?
if !(test -f nondefaultfiles); then
    echo "Making backups of files"
    cp /etc/passwd passwd
    cp /etc/shadow shadow
    cp /etc/group group
    cp /etc/gshadow gshadow
    cp /etc/sudoers sudoers
  echo "Backup complete"
    pause

    dpkg-query -W -f='${Conffiles}\n' '*' | awk 'OFS="  "{print $2,$1}' | md5sum -c 2>/dev/null | awk -F': ' '$2 !~ /OK/{print $1}' > nondefaultfiles
    cat nondefaultfiles
    echo "This is a list all of the configuration files that are not default, list saved to $(pwd)/nondefaultfiles"
    pause
  else
    echo "Skipping backups"
    pause
  fi

echo "Setting correct file permissions and ownership"
chown root:root /etc/passwd
chmod 644 /etc/passwd
chown root:root /etc/shadow
chmod o-rwx,g-wx /etc/shadow
chown root:root /etc/group
chmod 644 /etc/group
chown root:shadow /etc/gshadow
chmod o-rwx,g-rw /etc/gshadow
chown root:root /etc/passwd-
chmod u-x,go-wx /etc/passwd-
chown root:root /etc/shadow-
chown root:shadow /etc/shadow-
chmod o-rwx,g-rw /etc/shadow-
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-
chown root:root /etc/gshadow-
chown root:shadow /etc/gshadow-
chmod o-rwx,g-rw /etc/gshadow-

echo "Configuring cron"
systemctl enable cron
rm /etc/cron.deny
rm /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow
chown root:root /etc/crontab
chmod og-rwx /etc/crontab
chown root:root /etc/cron.hourly
chmod og-rwx /etc/cron.hourly
chown root:root /etc/cron.daily
chmod og-rwx /etc/cron.daily
chown root:root /etc/cron.weekly
chmod og-rwx /etc/cron.weekly
chown root:root /etc/cron.monthly
chmod og-rwx /etc/cron.monthly
chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d