##
# Author: Dave Long <dlong@cagedata.com>
# Created: 2020-02-14
# Last Modified: 2020-02-14 # Create function
#
# Installs a new license key on computer and activates it
##

$OSKey = "{[LicenseKey]}"
$SLMgr = "C:\Windows\System32\slmgr.vbs"

Write-Output "Inserting license key: $OSKey"
$InsertKey = & cscript $SLMgr /ipk $OSKey
$RetryCount = 3

while ($RetryCount -gt 0) {
    Write-Output "Activating license key..."
    & cscript $SLMgr /ato
    
    Write-Output "Verifying activation status"
    $SLMgrResult = & cscript $SLMgr /dli
    $LicenseStatus = ([string]($SLMgrResult | Select-String -Pattern "^License Status:")).Remove(0, 16)
    if ($LicenseStatus -match "Licensed") {
        Write-Host "Activation Successful" -ForegroundColor Green
        $retryCount = 0
    } else {
        Write-Error "Activation failed."
        $RetryCount -= 1
    }
}
