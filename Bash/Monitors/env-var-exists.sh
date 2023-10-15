#!/bin/bash
#
# Operating Systems: macOS & Linux
#
# Check to see if an environment variables exists.

# Name of the environment variable
ENV_VAR="SHELL" # Replace with desired environment variable

printenv | grep -q "^$ENV_VAR=*"

if [ $? -eq 0 ]; then
	echo "environment variable ${ENV_VAR} exists"
else
	echo "environment variable ${ENV_VAR} does not exists"
fi

