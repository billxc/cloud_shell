# cloud_shell
Create a unified and seamless cross-platform shell experience.

## Usage
1. Clone the repo
1. Run `init.ps1` or `init.sh`
1. (Window only) Add the repo to `PATH` or run `update_path.ps1`
1. Enjoy

## Functions
1. hist
Show all history commands, and filter with the `fzf` command
1. x
Show all available commands, and filter with the `fzf` command, choose one to execute


## Implementation
1. Very simple functions are implemented in `bash` or `powershell`
1. Leverage `fzf` to implement fuzzy search
1. Complex functions are implemented in `python`
