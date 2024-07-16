export CLOUD_SHELL_HOME=$HOME/.cloud_shell
CLOUD_SHELL_RC=$CLOUD_SHELL_HOME/shellrc/

source $CLOUD_SHELL_RC/pyvenv_rc.sh

export PATH="$CLOUD_SHELL_HOME:$PATH"
export PATH="$CLOUD_SHELL_HOME/sh:$PATH"
export PATH="$CLOUD_SHELL_HOME/local_commands:$PATH"

[ -f /$HOME/OneDrive/cloud_shell_mac/shellrc.sh ] && source /$HOME/OneDrive/cloud_shell_mac/shellrc.sh

