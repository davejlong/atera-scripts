###
# Author: Dave Long <dlong@cagedata.com>
# Created Date: 2020-01-21
# Description: Gets a list of all inactive computers and optionally disables them
###

function Get-InactiveComputers() {
  param(
  # Number of days before a computer in marked as inactive
  [Int] $InactiveDays=30,
  # Optionally disable computers who are not active
  [bool] $Disable=$False
  )
  if ($InactiveDays -gt 0) { $InactiveDays = 0 - $InactiveDays }
  # Any computer who hasn't logged in within this date
  # will be added to our list
  $InactiveDate = (Get-Date).AddDays(0-$InactiveDays)
  
  # Get all inactive computers in ActiveDirectory
  $Computers = Get-ADComputer -Filter { Enabled -eq $True -and LastLogonDate -le $InactiveDate }
  
  # Disable computers if needed
  if ($Disable) { $Computers | ForEach-Object { Set-ADComputer -Ideneity $_.SAMAccountName -Enabled $False } }

  return $Computers
}

Get-InactiveComputers -InactiveDays {[InactiveDays]}