#!/bin/bash

# Function to delete files manually
delete_manually() {
    for file in *.{mp3,mov,mp4,avi,mpg,mpeg,flac,m4a,flv,ogg,gif,png,jpg,jpeg}; do
        if [ -f "$file" ]; then
            read -p "Do you want to delete $file? (y/n): " answer
            if [ "$answer" == "y" ]; then
                rm "$file"
                echo "Deleted $file"
            else
                echo "Skipped $file"
            fi
        fi
    done
}

# Function to delete files automatically
delete_automatically() {
    for file in *.{mp3,mov,mp4,avi,mpg,mpeg,flac,m4a,flv,ogg,gif,png,jpg,jpeg}; do
        if [ -f "$file" ]; then
            rm "$file"
            echo "Deleted $file"
        fi
    done
}

# Ask the user for deletion method
read -p "Choose deletion method for files (m: manual, a: automatic): " method

# Perform deletion based on user's choice
if [ "$method" == "m" ]; then
    delete_manually
elif [ "$method" == "a" ]; then
    delete_automatically
else
    echo "Invalid choice"
fi
