###
# Author: Dave Long <dlong@cagedata.com>
# Created: 2019-07-29
# Last Modified: 2019-07-29 # Create function
#
# Sets a new password for a user in ActiveDirectory and
# requires user to change password on next login.
###

$user = Get-ADUser {[SamAccountNAme]}

if ($user) {
    Set-ADAccountPassword $user -NewPassword (ConvertTo-SecureString -AsPlainText -String "{[Password]}" -force)
    Set-ADUser $user -ChangePasswordAtLogon $True
} else {
    Write-Host "No user found by SamAccountName"
}
