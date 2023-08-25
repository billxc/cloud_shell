$parent = Split-Path $PSScriptRoot -Parent
& "$parent/venv/Scripts/python" $parent/py/hist.py | fzf