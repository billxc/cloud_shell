# pwsh show .ps1 files of $parent
$parent = Split-Path $PSScriptRoot -Parent

$command = (Get-ChildItem $parent -Filter "*.ps1" -Recurse | Select-Object -ExpandProperty Name | fzf)

echo "run: $command"

if (-not $command) {
    exit
}
& "$command"