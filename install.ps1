# Go to user home folder
Set-Location -Path $HOME

# Clone the repo
git clone https://github.com/billxc/cloud_shell.git .cloud_shell

Set-Location .cloud_shell
# Execute the init.ps1 in the .cloud_shell folder
& './init.ps1'