###
# Author: Dave Long <dlong@cagedata.com>
# Created: 2019-07-12
# Last Modified: 2019-07-12 # Create function
#
# Creates a VPN connection for connecting to an L2TP VPN server
###

function Add-L2TPVpnConnection {
  param(
    [string]$Name,
    [string]$ServerAddress,
    [string]$Psk
  )
  # Don't try to recreate the same VPN again.
  if (Get-VPNConnection | Where-Object Name -eq $Name) { return $true }
  
  Add-VpnConnection -Name $Name -ServerAddress $ServerAddress -TunnelType L2tp -L2tpPsk $Psk -EncryptionLevel Required -AuthenticationMethod MSChapv2 -RememberCredential -AllUserConnection -Force
}

Add-L2TPVpnConnection -Name "{[ConnectionName]}" -ServerAddress "{[ServerAddress]}" -Psk "{[PreSharedKey]}"
