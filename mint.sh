# TODO: Automatically backup /etc/groups and /etc/passwd

printf "\n-- Valence Linux Mint --\n\nMake sure this program is:\n- Run as root\n- Run in bash (not zsh)\n- Run with backed up /etc/group and /etc/passwd\n\n"
echo "USER DELETING AND PERMISSION MODIFYING:"
echo "Copy and paste 'Authorized Users' (press Ctrl+D two times when done):"
readarray -t userArray
adminArray=()

# shellcheck disable=SC2013
for name in $(cut -d: -f6 /etc/passwd | grep "^/home/" | sed 's|^/home/||'); do
  isUser=0
  isAdmin=0

  for element in "${userArray[@]}"; do
      if [[ "$name" == "$element" ]]; then
          isUser=1
          break
      fi
  done

  if [[ $isUser == 0 ]]; then
    echo ""
    read -r -p "Delete $name? (y/n): " delete

    if [[ "$delete" = "y" ]]; then
      userdel -f "$name"
      echo "Deleted $name"
    else
      read -r -p "Make $name administrator? (y/n): " admin

      if [[ "$admin" = "y" ]]; then
        adminArray+=("$name")
        usermod -aG sudo "$name"
        echo "Added $name to sudoers"

        # Escapes illegal characters found in password
        echo "$name:$(printf '%q' "IloveCyberPatriot@28")" | chpasswd
        echo "Changed $name's password to 'IloveCyberPatriot@28'"
      fi

      for element in "${adminArray[@]}"; do
          if [[ "$name" == "$element" ]]; then
              isAdmin=1
              break
          fi
      done

      if [[ $isAdmin == 0 ]]; then
        deluser "$name" sudo
        echo "Removed $name from sudoers"
      fi

      passwd -x30 -n3 -w7 "$name"
      echo "$name's max password age changed to 30 days"
      echo "$name's min password age changed to 3 days"
      echo "$name's password warning changed to 7 days"

      usermod -L "$name"
      echo "$name's account has been locked"
    fi
  fi
done