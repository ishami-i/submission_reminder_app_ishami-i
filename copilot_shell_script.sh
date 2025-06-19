#!/bin/bash
# Get the exact directory
dir=$(find . -maxdepth 1 -type d -name "submission_reminder_*" | head -n 1)

if [ -z "$dir" ]; then
    echo "Error: Could not find the submission_reminder directory."
    exit 1
fi
# Allowed assignment names
Assignment=("Shell Navigation" "Git" "Shell Basics")

read -p "Enter the assignment: " input

valid=false
for prompt in "${Assignment[@]}"; do
    if [[ "$input" == "$prompt" ]]; then
        valid=true
        # Update the ASSIGNMENT value in config.env
        # macOS sed fix
        sed -i '' "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$input\"/" "$dir/config/config.env"

    
        break
    fi
done

if ! $valid; then
    echo "Invalid input. Only these values are allowed; ${Assignment[*]}"
    exit 1
fi

# Run the startup script
"$dir/startup.sh"

