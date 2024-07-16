# Manages the global python environments, easily create and activate virtual environments

# The environments are stored in the ~/venvs/ directory
# Usage:
# no arguments, list all the virtual environments, and select one to activate
# pyvenv -n <name>, create a new virtual environment
# pyvenv <name>, activate a virtual environment

pyvenv() {
  name=""
  create_new=false
  delete=false

  while getopts ":n:d" opt; do
    case $opt in
    n)
      name="$OPTARG"
      create_new=true
      ;;
    d)
      delete=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      return 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      return 1
      ;;
    esac
  done

  venv_dir="$HOME/venvs"
  if [[ ! -d "$venv_dir" ]]; then
    mkdir -p "$venv_dir"
  fi

  ############################################
  # Create a new virtual environment
  ############################################
  if [[ "$name" != "" ]]; then
    env_dir="$venv_dir/$name"
    echo "Virtual environment: $env_dir"
    if $create_new; then
      echo "Creating new virtual environment $name"
      if [ -d "$env_dir" ]; then
        echo "Virtual environment $name already exists"
        return 1
      fi

      # deactivate the current environment if any
      if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
      fi

      python3 -m venv "$env_dir"
      echo "Virtual environment $name created"
      source "$env_dir/bin/activate"
    else
      if [ -d "$env_dir" ]; then
        # activate the environment
        source "$env_dir/bin/activate"
        echo "Virtual environment $name activated"
      else
        echo "Virtual environment $name does not exist"
        return 1
      fi
    fi
    echo "Done"
  fi

  ############################################
  # List all the virtual environments
  ############################################
  ls "$venv_dir" | fzf | while read -r line; do
    source "$venv_dir/$line/bin/activate"
    echo "Virtual environment $line activated"
  done
}
