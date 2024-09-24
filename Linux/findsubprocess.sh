#!/bin/bash

read -p "Enter the name of the target process: " targetProcess

echo "Searching for background processes that open '$targetProcess'..."

ps -e -o pid,ppid,comm | grep "$targetProcess" | while read -r processInfo; do
    processId=$(echo "$processInfo" | awk '{print $1}')
    parentProcessId=$(echo "$processInfo" | awk '{print $2}')
    processName=$(echo "$processInfo" | awk '{print $3}')

    echo "Process Name: $processName"
    echo "   Process ID: $processId"
    echo "   Parent Process ID: $parentProcessId"
    echo
done

echo "Search complete."
