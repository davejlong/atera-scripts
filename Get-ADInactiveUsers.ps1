###
# Author: Dave Long <dlong@cagedata.com>
# Created Date: 2019-08-01
# Description: Gets a list of all inactive users and optionally disables them
###

function Get-InactiveUsers($Disable=$False) {
    # Any user who hasn't logged in within this date
    # will be added to our list
    $InactiveDate = (Get-Date).AddDays(-30)

    # Get all active users in ActiveDirectory
    $Users = Get-ADUser -Filter 'Enabled -eq $True' -Properties LastLogonDate

    # Create a container Array to hold the list of
    # inactive users for later
    $InactiveUsers = @()

    # Loop through all of the users
    $Users | ForEach-Object {
	    # Check if the LastLogonDate is less than or equal to the InactiveDate (30 days ago)
	    if ($_.LastLogonDate -le $InactiveDate) {
		    # Add the user to our list if it hasn't logged in
		    $InactiveUsers += $_
            if ($Disable) { Set-ADUser $User -Enabled $False }
        }
    }
    return $InactiveUsers
}

Get-InactiveUsers