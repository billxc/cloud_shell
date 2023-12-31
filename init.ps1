function Add-Path {
  param(
    [Parameter(Mandatory, Position = 0)]
    [string] $LiteralPath,
    [ValidateSet('User', 'CurrentUser', 'Machine', 'LocalMachine')]
    [string] $Scope
  )

  Set-StrictMode -Version 1; $ErrorActionPreference = 'Stop'

  $isMachineLevel = $Scope -in 'Machine', 'LocalMachine'
  if ($isMachineLevel -and -not $($ErrorActionPreference = 'Continue'; net session 2>$null)) { throw "You must run AS ADMIN to update the machine-level Path environment variable." }

  $regPath = 'registry::' + ('HKEY_CURRENT_USER\Environment', 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment')[$isMachineLevel]

  # Note the use of the .GetValue() method to ensure that the *unexpanded* value is returned.
  $currDirs = (Get-Item -LiteralPath $regPath).GetValue('Path', '', 'DoNotExpandEnvironmentNames') -split ';' -ne ''

  if ($LiteralPath -in $currDirs) {
    Write-Verbose "Already present in the persistent $(('user', 'machine')[$isMachineLevel])-level Path: $LiteralPath"
    return
  }

  $newValue = ($currDirs + $LiteralPath) -join ';'

  # Update the registry.
  Set-ItemProperty -Type ExpandString -LiteralPath $regPath Path $newValue

  # Broadcast WM_SETTINGCHANGE to get the Windows shell to reload the
  # updated environment, via a dummy [Environment]::SetEnvironmentVariable() operation.
  $dummyName = [guid]::NewGuid().ToString()
  [Environment]::SetEnvironmentVariable($dummyName, 'foo', 'User')
  [Environment]::SetEnvironmentVariable($dummyName, [NullString]::value, 'User')

  # Finally, also update the current session's `$env:Path` definition.
  # Note: For simplicity, we always append to the in-process *composite* value,
  #        even though for a -Scope Machine update this isn't strictly the same.
  $env:Path = ($env:Path -replace ';$') + ';' + $LiteralPath

  Write-Verbose "`"$LiteralPath`" successfully appended to the persistent $(('user', 'machine')[$isMachineLevel])-level Path and also the current-process value."
}

Write-Output "adding current dir $PSScriptRoot into path"
Add-Path $PSScriptRoot
Write-Output "adding pwsh dir $PSScriptRoot/pwsh into path"
Add-Path $PSScriptRoot/pwsh

$onedrive_dirs = @()

# Default OneDrive Dirs
$default_onedrive_dir = Join-Path -Path $HOME -ChildPath "OneDrive/cloud_shell"
$onedrive_dirs += $default_onedrive_dir

# Other o365 OneDrive Dirs(all folders under ~/, and starts with "OneDrive - ")
Get-ChildItem -Path $HOME -Directory | ForEach-Object {
    if ($_.Name.StartsWith("OneDrive - ")) {
        $onedrive_dir = Join-Path -Path $HOME -ChildPath "$($_.Name)/cloud_shell"
        $onedrive_dirs += $onedrive_dir
    }
}

# Add OneDrive Dirs into path
foreach ($onedrive_dir in $onedrive_dirs) {
    # We are not testing if the dir exists, because we want to add the dir into path even if it is not exists
    # User may create the dir later
    Write-Output "adding onedrive dir $onedrive_dir into path"
    Add-Path $onedrive_dir
}


# install scoop if not installed
if (Get-Command scoop -ErrorAction SilentlyContinue) {
  Write-Output "scoop is installed, Skip installing scoop"
} else {
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
  Write-Output "scoop installed"
  $env:Path = $env:Path + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");
  Write-Output "scoop added to path"
}
scoop bucket add extras

# check if python is installed
if ($python3_path = Get-Command python3 -ErrorAction SilentlyContinue) {
  # Windows have shim for python3 install, check if it is a shim
  $win_fake_python3 = Join-Path $env:USERPROFILE "AppData\Local\Microsoft\WindowsApps\python3.exe"
  if ($python3_path.Path -eq $win_fake_python3) {
    Write-Output "python3 is a win11 shim for python install, use scoop to install it"
    scoop install python
    Write-Output "Please disable the python shortcut from Settings > Manage App Execution Aliases."
    Write-Output "After that, rerun this script to continue"
    exit 1
  } else {
    Write-Output "python3 is installed, Skip installing python3"
  }
  # TODO: need to install python3 if the python3 is a win11 shim for python install
} else {
  Write-Output "python3 not installed, use scoop to install it"
  scoop install python
}

# init python3 venv if not exists
if (Test-Path $PSScriptRoot/venv) {
  Write-Output "venv exists, Skip init venv"
} else {
  Write-Output "init venv"
  python3 -m venv $PSScriptRoot/venv
}

& "$PSScriptRoot/venv/Scripts/pip" install -r $PSScriptRoot/requirements.txt -U

scoop install $(Get-Content $PSScriptRoot/scoop_apps.txt) 
