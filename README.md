# cloud_shell
Xiaochen's cloud shell, a unified shell experience across different platforms(Mac, Windows, Linux).

Using the python technology stack to implement the shell functions, and leverage the `fzf` to implement the fuzzy search.

Note: This repo is still under development, and the commands are not yet available on some platforms yet. (Currently, most commands works on windows platform)

## Installation

iwr pwsh.xccc.me | iex


<!-- ## Usage
1. Clone the repo
1. Run `init.ps1` or `init.sh`
1. (Window only) Add the repo to `PATH` or run `update_path.ps1`
1. Enjoy -->

## Highlighted Functions

see all in [full_commands.md](full_commands.md)

1. hist

    Show all history commands, and filter with the `fzf` command

1. x

    Show all available commands, and filter with the `fzf` command, choose one to execute

1. reloadpath

    reload the `PATH` environment variable, useful when you add a new path to the environment variable

1. update_cloud_shell

    update the cloud_shell repo

1. to
    `to` uses the chatGPT to generate the command you want to execute, and then execute it.


## Implementation
1. Very simple functions are implemented in `bash` or `powershell`
1. Leverage `fzf` to implement fuzzy search
1. Complex functions are implemented in `python`
