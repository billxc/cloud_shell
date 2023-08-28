# get parent directory of this script
$parent = Split-Path $PSScriptRoot -Parent

$cmd = & "$parent/venv/Scripts/python" $parent/py/natural-cli.py $parent $args

echo "execute the: $cmd"
# run the command
Invoke-Expression $cmd