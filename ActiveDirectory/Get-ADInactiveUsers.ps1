###
# Author: Dave Long <dlong@cagedata.com>
# Created Date: 2020-01-21
# Description: Gets a list of all inactive users and optionally disables them
###

function Get-InactiveUsers() {
  param(
  # Number of days before a user in marked as inactive
  [Int] $InactiveDays=30,
  # Optionally disable users who are not active
  [bool] $Disable=$False
  )
  if ($InactiveDays -gt 0) { $InactiveDays = 0 - $InactiveDays }
  # Any user who hasn't logged in within this date
  # will be added to our list
  $InactiveDate = (Get-Date).AddDays(0-$InactiveDays)
  
  # Get all inactive users in ActiveDirectory
  $Users = Get-ADUser -Filter { Enabled -eq $True -and LastLogonDate -le $InactiveDate }
  
  # Disable users if needed
  if ($Disable) { $Users | ForEach-Object { Set-ADUser -Ideneity $_.SAMAccountName -Enabled $False } }

  return $Users
}

Get-InactiveUsers -InactiveDays {[InactiveDays]}