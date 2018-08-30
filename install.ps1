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

    if (Test-Path "$env:Temp/fusionauth") {
        Remove-Item -Force -Recurse "$env:Temp/fusionauth"
    }

    New-Item "$env:Temp/fusionauth" -ItemType Directory

    Expand-Archive -Path $tempFile -DestinationPath "$env:Temp/fusionauth"

    New-Item $destination -ItemType Directory -ea 0

    robocopy "$env:Temp/fusionauth" $destination /E /XC /XN /XO /NFL /NDL /NJH /NS /NC
}

Write-Output "Getting latest version"

$VERSION= Invoke-WebRequest -Uri https://www.inversoft.com/api/fusionauth/latest-version

DownloadAndExpandZip "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-app-${VERSION}.zip" "$env:Temp\fusionauth-app.zip" "$env:UserProfile\fusionauth"
DownloadAndExpandZip "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-search-${VERSION}.zip" "$env:Temp\fusionauth-search.zip" "$env:UserProfile\fusionauth"

if (Test-Path "$env:UserProfile\fusionauth\fusionauth-app") {
    Remove-Item -Force -Recurse "$env:UserProfile\fusionauth\fusionauth-app"
}
if (Test-Path "$env:UserProfile\fusionauth\fusionauth-search") {
    Remove-Item -Force -Recurse "$env:UserProfile\fusionauth\fusionauth-search"
}

Move-Item -Path "$env:UserProfile\fusionauth\fusionauth-app-${VERSION}" -Destination "$env:UserProfile\fusionauth\fusionauth-app"
Move-Item -Path "$env:UserProfile\fusionauth\fusionauth-search-${VERSION}" -Destination "$env:UserProfile\fusionauth\fusionauth-search"

# Restore old setting
$erroractionpreference = $old_erroractionpreference # Reset $erroractionpreference to original value
