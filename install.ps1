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

$VERSION= Invoke-WebRequest -Uri https://www.inversoft.com/api/fusionauth/latest-version

DownloadAndExpandZip "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-app-${VERSION}.zip" "$env:Temp\FusionAuth-app.zip" "$env:UserProfile\FusionAuth"
DownloadAndExpandZip "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-search-${VERSION}.zip" "$env:Temp\FusionAuth-search.zip" "$env:UserProfile\FusionAuth"

if (Test-Path "$env:UserProfile\FusionAuth\fusionAuth-app") {
    Remove-Item -Force -Recurse "$env:UserProfile\FusionAuth\fusionAuth-app"
}
if (Test-Path "$env:UserProfile\FusionAuth\fusionAuth-search") {
    Remove-Item -Force -Recurse "$env:UserProfile\FusionAuth\fusionAuth-search"
}

Move-Item -Path "$env:UserProfile\FusionAuth\fusionAuth-app-${VERSION}" -Destination "$env:UserProfile\FusionAuth\fusionAuth-app"
Move-Item -Path "$env:UserProfile\FusionAuth\fusionAuth-search-${VERSION}" -Destination "$env:UserProfile\FusionAuth\fusionAuth-search"

# Restore old setting
$erroractionpreference = $old_erroractionpreference # Reset $erroractionpreference to original value
