# pwsh show .ps1 files of $PSScriptRoot
$command = (Get-ChildItem $PSScriptRoot -Filter "*.ps1" -Recurse | Select-Object -ExpandProperty Name | fzf)

echo "run $command"
& "$command"