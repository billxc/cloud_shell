# call python script with all arguments
$parent = Split-Path $PSScriptRoot -Parent

& "$parent/venv/Scripts/python" $parent/py/ospath.py $args