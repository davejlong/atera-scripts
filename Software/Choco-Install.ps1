###
# Author: Dave Long <dlong@cagedata.com>
#
# Installs a chocolatey package. Installed Chocolatey itself before hand if needed.
###

$cinst = Join-Path -Path $env:ProgramData -ChildPath "chocolatey\bin\cinst.exe"

if (!(Test-Path $cinst)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

& $cinst --yes "{[package]}"
