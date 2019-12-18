###
# Author: Dave Long <dlong@cagedata.com>
#
# Enabled RDP on a local work station and allows access for specified user
###

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="remote desktop" new enable=yes

net localgroup "remote desktop users" {[User]}
