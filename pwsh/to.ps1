# get parent directory of this script
$parent = Split-Path $PSScriptRoot -Parent

$cmd = & "$parent/venv/Scripts/python" $parent/py/natural-cli.py $parent $args

# run the command
Invoke-Expression $cmd