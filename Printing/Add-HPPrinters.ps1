###
# Author: Dave Long <dlong@cagedata.com>
#
# Sets up HP printers on systems using the PCL 6 Universal driver. Also sets the default
# printer for all users.
#
# To configure:
# * Fill in the $Printers dictionary with the IP of each printer and the name it should be
#   setup with on the computer.
# * Set the $DefaultPrinter variable to the name of the printer that should be default
###

$RemovedPrinters = @("NPI*")

$Printers = @{
    "192.168.1.5"="Office Printer";
    "192.168.1.6"="Aux Office Printer";
}
$DefaultPrinter = "Office Printer"
$DriverName = "HP Universal Printing PCL 6"

function Install-HPDriver($DriverName) {
  if(Get-PrinterDriver | Where-Object Name -eq $DriverName) { return $true }
  $DriverUri = "https://www.dropbox.com/s/40jdl2ogkogdn9c/win10-x64-hp-universal-pcl6.zip?dl=1"
  $DownloadFile = Join-Path -Path $env:TEMP -ChildPath win10-x64-hp-universal-pcl6.zip
  $DriverTempPath = Join-Path -Path $env:TEMP -ChildPath hp-universal-pcl6

  if ($(Test-Path $DriverTempPath) -eq $false) {
      Invoke-WebRequest -Uri $DriverUri -OutFile $DownloadFile
      Expand-Archive -Path $DownloadFile -DestinationPath $DriverTempPath
  }

  $DriverName = "HP Universal Printing PCL 6"

  # Install the driver
  $DriverPath = Join-Path -Path $DriverTempPath -ChildPath hpcu220u.inf
  $PnpUtil = Join-Path -Path $env:windir -ChildPath "System32\pnputil.exe"
  & "$PnpUtil" /add-driver $DriverPath
  Add-PrinterDriver -Name $DriverName
}

function Install-Printer($Address, $Name) {
  if (Get-Printer | Where-Object Name -eq $Name) { return $true }
  Add-PrinterPort -Name "IP_$($Address)" -PrinterHostAddress $Address
  Add-Printer -Name $Name -PortName "IP_$($Address)" -DriverName $DriverName
}

Install-HPDriver($DriverName)

foreach($Printer in $RemovedPrinters) {
    Remove-Printer $Printer
}

# Setup each of the printers
foreach($Printer in $Printers.GetEnumerator()) {
  Install-Printer -Address $Printer.Name -Name $Printer.Value
}

# Set the default printer
$Printer = Get-WmiObject -Class Win32_Printer -Filter "Name='$($DefaultPrinter)'"
$Printer.SetDefaultPrinter()
