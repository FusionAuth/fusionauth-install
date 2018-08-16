# Get current setting
$old_erroractionpreference = $erroractionpreference
$erroractionpreference = 'stop' # quit if anything goes wrong

# Try importing BitsTransfer
if (!(Get-module BitsTransfer)) {
    Import-Module BitsTransfer -ErrorAction SilentlyContinue
}

if(($PSVersionTable.PSVersion.Major) -lt 5) {
    Write-Output "PowerShell 5 or greater is required to run this installer."
    Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}

# show notification to change execution policy:
if((get-executionpolicy) -gt 'RemoteSigned') {
    Write-Output "PowerShell requires an execution policy of 'RemoteSigned' to run our installer."
    Write-Output "To make this change please run:"
    Write-Output "'Set-ExecutionPolicy RemoteSigned -scope CurrentUser'"
    break
}

function DownloadAndExpandZip($uri, $tempFile, $destination) {
    Write-Output "Downloading archive"

    if (Get-module BitsTransfer) {
        Start-BitsTransfer -Source $uri -Destination $tempFile
    } else {
        (New-Object System.Net.WebClient).DownloadFile($uri, $tempFile)
    }

    Write-Output "Expanding archive"

    if (Test-Path "$env:Temp/FusionAuth") {
        Remove-Item -Force -Recurse "$env:Temp/FusionAuth"
    }

    New-Item "$env:Temp/FusionAuth" -ItemType Directory

    Expand-Archive -Path $tempFile -DestinationPath "$env:Temp/FusionAuth"

    New-Item $destination -ItemType Directory -ea 0

    robocopy "$env:Temp/FusionAuth" $destination /E /XC /XN /XO /NFL /NDL /NJH /NS /NC
}

Write-Output "Getting latest version"

$VERSION= Invoke-WebRequest -Uri https://www.inversoft.com/latest-passport-version

DownloadAndExpandZip "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-backend-${VERSION}.zip" "$env:Temp\FusionAuth-backend.zip" "$env:UserProfile\FusionAuth"
DownloadAndExpandZip "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-search-engine-${VERSION}.zip" "$env:Temp\FusionAuth-search-engine.zip" "$env:UserProfile\FusionAuth"

New-Item -Force -Path "$env:UserProfile/FusionAuth/fusionAuth-backend" -ItemType SymbolicLink -Value "$env:UserProfile/FusionAuth/passport-backend-${VERSION}"
New-Item -Force -Path "$env:UserProfile/FusionAuth/fusionAuth-search-engine" -ItemType SymbolicLink -Value "$env:UserProfile/FusionAuth/passport-search-engine-${VERSION}"

# Restore old setting
$erroractionpreference = $old_erroractionpreference # Reset $erroractionpreference to original value
