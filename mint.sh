# TODO: Automatically backup /etc/groups and /etc/passwd

printf "\n-- Valence Linux Mint --\n\nMake sure this program is:\n- Run as root\n- Run in bash (not zsh)\n- Run with backed up /etc/group and /etc/passwd\n\n"
echo "USER DELETING AND PERMISSION MODIFYING:"
echo "Copy and paste 'Authorized Users' (press Ctrl+D two times when done):"
readarray -t userArray
adminArray=()

# shellcheck disable=SC2013
for name in $(cut -d: -f6 /etc/passwd | grep "^/home/" | sed 's|^/home/||'); do
  userFound=0
  adminFound=0

  for element in "${userArray[@]}"; do
      if [[ "$name" == "$element" ]]; then
          userFound=1
          break
      fi
  done

  if [[ $userFound == 0 ]]; then
    echo ""
    read -r -p "Delete $name? (y/n): " delete

    if [[ "$delete" = "y" ]]; then
      userdel -f "$name"
    else
      read -r -p "Make $name administrator? (y/n): " admin

      if [[ "$admin" = "y" ]]; then
        adminArray+=("$name")
        usermod -aG sudo "$name"
        read -r -p "$name's password: " password
        echo "$name:$password" | chpasswd
      fi
    fi
  fi

  for element in "${adminArray[@]}"; do
      if [[ "$name" == "$element" ]]; then
          adminFound=1
          break
      fi
  done

  if [[ $adminFound == 0 ]]; then
    deluser "$name" sudo
  fi
done