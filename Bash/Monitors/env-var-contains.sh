#!/bin/bash
#
# Operating Systems: macOS & Linux
#
# Check to see if an environment variables contains a specified value.

# Name of the environment variable
ENV_VAR="SHELL" # Replace with desired environment variable

# Text environment variable's value may contain
CONTAINS="zsh" # Replace with text environment variable should contain

printenv | grep "^$ENV_VAR=*" | grep -q $CONTAINS

if [ $? -eq 0 ]; then
	echo "$ENV_VAR environment variable does contain $CONTAINS"
else
	echo "$ENV_VAR environment variable does not contain $CONTAINS"
fi

