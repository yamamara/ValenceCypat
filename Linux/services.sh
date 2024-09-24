#!/bin/bash


# Prompt the user to choose the mode
read -p "Choose the mode to disable services (a for automatic, m for manual): " mode

# Convert the input to lowercase
mode=${mode,,}

# Check the user's choice
if [ "$mode" = "a" ]; then
    # Automatic mode: Disable all services
    sudo systemctl disable --now --all
    echo "All services have been automatically disabled."
else
    # Manual mode: Prompt the user to disable individual services
    echo "Enter the services to disable (space-separated) or 'q' to quit:"
    read -a services

    # Disable the selected services
    for service in "${services[@]}"; do
        sudo systemctl disable --now "$service"
        echo "Disabled service: $service"
    done
fi


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

echo "All selected programs removed."
