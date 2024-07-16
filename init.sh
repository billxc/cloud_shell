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

#######################################################################################################
# install brew if not installed
if ! command -v brew &> /dev/null
then
    echo "brew not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# end install brew
#######################################################################################################

# CLOUD_SHELL_HOME should be $HOME/.cloud_shell
# TODO: support other locations

# if source $HOME/.cloud_shell/shellrc/cloud_shell_rc.sh is not in the rc file, add it
grep -q "source \$HOME/.cloud_shell/shellrc/cloud_shell_rc.sh" "$HOME/$RC_FILE" || echo "source \$HOME/.cloud_shell/shellrc/cloud_shell_rc.sh" >> "$HOME/$RC_FILE"