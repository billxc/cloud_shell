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

1. gitc
`gitc <word1> <word2> <word3>` ... is the Shortcut of  `git commit -m "<word1> <word2> <word3> ..."`
no bother to type the double quotes around the commit message

1. gitcc
same as `gitc`, but git will run `git add .` before commit

1. reloadpath
reload the `PATH` environment variable, useful when you add a new path to the environment variable

1. update_cloud_shell
update the cloud_shell repo

1. ospath
convert the path to the corresponding path in current OS.

1. slashpath
deal with the `/` and `\` in the path, convert it to `/` regardless of the OS.

## Implementation
1. Very simple functions are implemented in `bash` or `powershell`
1. Leverage `fzf` to implement fuzzy search
1. Complex functions are implemented in `python`
