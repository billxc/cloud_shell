$parent = Split-Path $PSScriptRoot -Parent
# call python with all arguments
& "$parent/venv/Scripts/python" $parent/py/multi_fetch.py $args