# Manages the global python environments, easyily create and activate virtual environments

# The environments are stored in the ~/venvs/ directory
# Usage:
# no arguments, list all the virtual environments, and select one to activate
# pyvenv -n <name>, create a new virtual environment
# pyvenv <name>, activate a virtual environment

param (
  [Parameter(Mandatory=$false)]
  [string]$name,
  [Parameter(Mandatory=$false)]
  [Switch]$n,
  [Parameter(Mandatory=$false)]
  [Switch]$d
)

$venvDir = "$env:USERPROFILE\venvs"
if (-not (Test-Path $venvDir)) {
  New-Item -Path $venvDir -ItemType Directory
}


############################################
# Create a new virtual environment
############################################
if($name -ne "") {
  $envDir = "$venvDir\$name"
  Write-Host "Virtual environment: $envDir"
  # check the -n flag
  if($n) {
    Write-Host "Creating new virtual environment $name"
    if (Test-Path $envDir) {
      Write-Host "Virtual environment $name already exists"
      return
    }

    # deactivate the current environment if any
    if($null -ne $env:VIRTUAL_ENV) {
      deactivate
    }

    python -m venv $envDir
    Write-Host "Virtual environment $name created"
    & $venvDir/$name/Scripts/Activate.ps1
    return
  } else {
    if (Test-Path $envDir) {
      # activate the environment
      & $envDir/Scripts/Activate.ps1
      Write-Host "Virtual environment $name activated"
      return
    } else {
      Write-Host "Virtual environment $name does not exist"
      return
    }
  }
  return
}
 
 
############################################
# List all the virtual environments
############################################
Get-ChildItem $venvDir | ForEach-Object { Write-Output $_.Name } | fzf | ForEach-Object { 
    &  $venvDir/$_/Scripts/Activate.ps1
    Write-Host "Virtual environment $_ activated"
}