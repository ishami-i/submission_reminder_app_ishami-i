#!/bin/bash

# Always work from the directory of this script
cd "$(dirname "$0")" || exit 1

# Source config and functions
source ./config/config.env
source ./modules/functions.sh

# Run reminder
bash ./app/reminder.sh
