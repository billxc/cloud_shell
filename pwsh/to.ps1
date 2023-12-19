# get parent directory of this script
$parent = Split-Path $PSScriptRoot -Parent

& "$parent/venv/Scripts/python" $parent/py/natural-cli.py $args

# # run the command
# # Ask User to confirm
# $confirm = Read-Host "Are you sure you want to run this command? (Y/n)"
# if ("n" -eq $confirm) {
#   exit
# }
# Invoke-Expression $cmd