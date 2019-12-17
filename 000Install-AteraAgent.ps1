# The Atera installer needs a Customer ID and an Integrator
# Login (an email of a user in Atera) which is used to affiliate
# an Agent with a specific Customer within the Atera account.
# The Customer ID and Integrator login can be hard coded below
# or passed in when the script is run. You also need to set your
# Atera Instance Host which is the host name of your portal.

# Usage:
# powershell -executionpolicy bypass -f ./Install-AteraAgent.ps1 [-customer <customer_id>] [-integrator <integrator_login>] [-portalhost <atera_portal_host>]

# !!! You can hard code your account and organization keys below or specify them on the command line

# optional command line params, this has to be the first line in the script
param (
  [string]$portalhost,
  [string]$customer,
  [string]$integrator
)

# Hostname of the Atera Customer Portal
$AteraInstanceHost = "__YOUR ATERA HOST HERE__"

# The CustomerID can be obtained by visiting the Customer's page in Atera
# and getting the number from the end of the URL
$CustomerId="__CUSTOMER ID HERE__"
# The Integrator Login has to be the email of a user in Atera
$IntegratorLogin="__YOUR EMAIL HERE__"

if (![string]::IsNullOrEmpty($portalhost)) { $AteraInstanceHost = $portalhost }
if (![string]::IsNullOrEmpty($customer)) { $CustomerId = $customer }
if (![string]::IsNullOrEmpty($integrator)) { $IntegratorLogin = $integrator }

$DownloadUrl = "$AteraInstanceHost/GetAgent/Msi/?customerId=$CustomerId&IntegratorLogin=$IntegratorLogin"
$ServiceName = "AteraAgent"
$InstallerName = "AteraAgent.exe"
$InstallerPath = Join-Path $env:TEMP $InstallerName

function Get-Timestamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function Test-Parameters {
    if ([string]::IsNullOrEmpty($AteraInstanceHost) -or $AteraInstanceHost -eq "__YOUR ATERA_HOST HERE__") {
        Write-Error "$(Get-Timestamp) Atera host not provided"
        throw "Script failed!"
    }
    if ([string]::IsNullOrEmpty($CustomerId) -or $CustomerId -eq "__CUSTOMER ID HERE__") {
        Write-Error "$(Get-Timestamp) Customer ID not provided"
        throw "Script failed!"
    }
    if ([string]::IsNullOrEmpty($IntegratorLogin) -or $IntegratorLogin -eq "__YOUR EMAIL HERE__") {
        Write-Error "$(Get-Timestamp) Integrator Login not provided"
        throw "Script failed!"
    }
}

function Get-Installer {
    Write-Debug "$(Get-Timestamp) Getting Atera Installer"
    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
    } catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error "$(Get-Timestamp) $ErrorMessage"
    }
}

function Install-Atera {
    Write-Debug "$(Get-Timestamp) Installed Atera Agent"
    if(!!(Get-Service $ServiceName -ErrorAction SilentlyContinue)) {
        Write-Error "$(Get-Timestamp) Atera Agent already installed. Exiting."
        exit 0
     }

     if (!(Test-Path $InstallerPath)) {
        Write-Error "$(Get-Timestamp) Agent installer unexpectadly removed from $InstallerPath. A security product may have quarantined the installer."
        throw "Script failed!"
     }

     Start-Process (Join-Path $env:SystemRoot "system32\msiexec.exe") -Wait -ArgumentList "/I $InstallerPath /quiet"
}

function Test-Installation {
    Write-Debug "$(Get-Timestamp) Testing installation"
    $AteraPath = Join-Path $env:ProgramFiles "\ATERA Networks\AteraAgent"
    if (!(Test-Path $AteraPath)) {
        Write-Error "Atera directory cannot be found at $AteraPath."
        throw "Script failed!"
    }
    if (!(Get-Service $ServiceName)) {
        Write-Error "Atera service not found ($ServiceName)"
        throw "Script failed!"
    }
    return true
}

function main {
    Test-Parameters
    
    Get-Installer
    Install-Atera
    Test-Installation
    Write-Host "$(Get-Timestamp) Atera Agent installed successfully!"
}

try {
    main
} catch {
    $ErrorMessage = $_.Exception.Message
    Write-Error $ErrorMessage
    exit 1
}
        
