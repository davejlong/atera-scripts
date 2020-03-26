###
# Author: Dave Long <dlong@cagedata.com>
# Date: 2020-03-26
#
# Description: Generates an alert in Atera for the local machine.
###
$AteraAPI = "https://app.atera.com/api/v3"
$AteraAPIKey = ""

function New-DeviceAlert {
  param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [System.Object] $Device,
    [Parameter(Mandatory=$true)]
    [String] $Title,
    [Parameter(Mandatory=$false)]
    [String] $AlertMessage,
    [Parameter(Mandatory=$false)]
    [ValidateSet('Information','Warning','Critical')]
    [String] $Severity,
    [Parameter(Mandatory=$false)]
    [ValidateSet('Hardware','Disk','Availability','Performance','Exchange','General')]
    [String] $AlertCategoryID
  )
  $data = @{
    "DeviceGuid" = $Device.DeviceGuid
    "CustomerID" = $Device.CustomerID
    "Title" = $Title
    "Severity" = $Severity
    "AlertCategoryID" = $AlertCategoryID
    "AlertMessage" = $AlertMessage
  }
  New-AteraPostRequest -Endpoint "/alerts" -ApiKey $AteraAPIKey -Data $data
}

function Get-Device {
  $data = New-AteraGetRequest -Endpoint "/agents/machine/$($env:COMPUTERNAME)" -ApiKey $AteraAPIKey
  if ($data.totalItemCount -eq 0) {
    Write-Error "No device found with computer name $($env:COMPUTERNAME)."
  }
  return $data.items[0]
}

function New-AteraGetRequest {
  Param(
    [Parameter(Mandatory=$true)]
    [String] $Endpoint,
    [Parameter(Mandatory=$true)]
    [String] $ApiKey
  )
  $Headers = @{
    "X-API-KEY" = $ApiKey;
    "Accept" = "application/json"
  }
  Invoke-RestMethod -Uri "$($AteraAPI)$($Endpoint)" -Headers $Headers
}

function New-AteraPostRequest {
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [System.Object] $Data,
    [Parameter(Mandatory=$true)]
    [String] $Endpoint,
    [Parameter(Mandatory=$true)]
    [String] $ApiKey
  )

  $Headers = @{
    "X-API-KEY" = $ApiKey;
    "Accept" = "application/json"
  }
  Invoke-RestMethod -Method Post -Uri "$($AteraAPI)$($EndPoint)" -Headers $Headers -Body $Data
}

$Device = Get-Device
$Alert = New-DeviceAlert -Device $Device -Title "Testing" -Severity "Warning" -AlertCategoryID "Hardware" -AlertMessage "Testing creating alerts from PowerShell"
Write-Host "Created alert $($Alert.ActionID)"