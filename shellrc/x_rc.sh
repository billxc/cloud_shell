built_in_cmds=(
  "pyvenv"
  "git fetch origin 'refs/tags/*:refs/tags/*'"
)


x(){
  # combine $built_in_cmds and local commands
  cmds=($built_in_cmds)

  # Read the file line by line
  while IFS= read -r line; do
      cmds+=("$line")
  done < "$HOME/OneDrive/cloud_shell_mac/local_commands.sh"

  if [ -z "$1" ]
  then
    selected_command=$(printf '%s\n' "${cmds[@]}" | fzf --height 10)
    # ls -G /local_commands/ | fzf | read cmd_file
  else
    selected_command=$(printf '%s\n' "${cmds[@]}" | fzf -q $1 --height 10)
  fi

  if [ -z "$selected_command" ]
  then
    echo "No command selected"
    return 1
  else
    echo $selected_command
    eval $selected_command
    echo $selected_command > ~/.cloud_shell/.x_last_select
    return 0
  fi
}

xx(){
  if [ -f ~/.cloud_shell/.x_last_select ]
  then
    last_command=$(cat ~/.cloud_shell/.x_last_select)
    echo "Running last command:"
    echo "$last_command"
    eval $last_command
  else
    echo "No last command found"
  fi
}