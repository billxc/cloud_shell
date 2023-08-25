#!/bin/bash

# Get the name of the current shell
SHELL_NAME=$(basename "$SHELL")

# Set the default rc file name based on the shell name
if [ "$SHELL_NAME" = "bash" ]; then
    RC_FILE=".bashrc"
elif [ "$SHELL_NAME" = "zsh" ]; then
    RC_FILE=".zshrc"
else
    echo "Unsupported shell: $SHELL_NAME"
    exit 1
fi

# Phe path to the rc file
# echo "$HOME/$RC_FILE"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Append DIR to PATH in the rc file
echo "export PATH=\$PATH:$DIR" >> "$HOME/$RC_FILE"
