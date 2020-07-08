###
# Author: Dave Long <dlong@cagedata.com>
# Created: 2020-07-08
# Last Modified: 2020-07-08 # Create function
#
# Fixes the computer name for Splashtop to match the hostname.
###

ComputerName = hostname
if (Get-Item -Path "HKLM:\SOFTWARE\Splashtop Inc.\Splashtop Remote Server" -ErrorAction SilentlyContinue) {
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Splashtop Inc.\Splashtop Remote Server" -Name CloudComputerName -Value $ComputerName
} else {
  Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server" -Name CloudComputerName -Value $ComputerName
}

Restart-Service SplashtopRemoteService
