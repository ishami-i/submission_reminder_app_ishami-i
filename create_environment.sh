#!/bin/bash
#prompt to get name of user 
echo "enter your name:"
read -r name
mkdir submission_reminder_"$name"

#creating directories in submission_reminder_"$name"
cd submission_reminder_"$name" || exit
mkdir app modules assets config
touch startup.sh
chmod +x startup.sh

# Create reminder.sh in app directory
cat << 'EOF' > app/reminder.sh 
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF
chmod +x app/reminder.sh
echo "reminder.sh being created in app directory"

#creating functions.sh in modules directory 
cat << 'EOF' > modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
chmod +x modules/functions.sh
echo "functions.sh being created in modules directory"

#creating config.env in config directory

cat << 'EOF' > config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF
chmod +x config/config.env
echo "config.env being created in config directory"

#creating submission.txt in assets
cat << 'EOF' > assets/submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Kiallah, Shell Basics, submitted
Kelvin, Shell Basics, not submitted
Ines, Shell Navigation, not submitted
Yvette, Shell Navigation, submitted
Shimwa, Git, not submitted
Ishimwe, Git, not submitted
EOF
echo "submission.txt being created in assets directory"
cat << 'EOF' > startup.sh
#!/bin/bash

# Always work from the directory of this script
cd "$(dirname "$0")" || exit 1

# Source config and functions
source ./config/config.env
source ./modules/functions.sh

# Run reminder
bash ./app/reminder.sh
EOF
chmod +x startup.sh
echo "creating startup.sh file."
echo "--------------------------------------"
echo "Done creating submission_reminder_""$name"
