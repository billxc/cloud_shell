#!/bin/bash

# Get the path to the directory containing this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PARAMS="$*"

# Call the Python script with all the parameters
git commit -m "$PARAMS"