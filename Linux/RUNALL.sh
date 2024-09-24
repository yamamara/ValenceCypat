#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Script is not running with admin privileges."
    sleep 9999
fi


current_user=$SUDO_USER
cd "/home/$current_user/Downloads/Team1CyPat-main/Linux"

bash misc.sh
bash delbannedfiles.sh
bash users.sh

echo "look into these files, saved into dir"
echo "List of world writable files"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -0002 > worldwritable
cat worldwritable
echo "List of unowned files"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser > unowned
cat unowned
echo " List of ungrouped files"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nogroup > ungrouped
cat ungrouped
echo "List of SUID executables"
df --local -P | awk {'if (NR!=1)print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000 > SUID
cat SUID
echo "List of SGID executables"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -2000 > SGID
cat SGID

echo -n "Write these down somewhere. Press Enter to continue: "
read

cd "/home/$current_user/Downloads/Team1CyPat-main/Linux/hardening-master"
bash ubuntu.sh