param (# This must come first
    [bool]$IncludeSearch = 0
)

function DownloadAndExpandZip($uri, $tempFile, $destination)
{
    Write-Output "Downloading archive, destination $destination"
    Invoke-WebRequest -Uri $uri -OutFile $tempFile

    Write-Output "Expanding archive"
    Expand-Archive -Force -Path $tempFile -DestinationPath "$destination"
}

# Get current setting
$old_erroractionpreference = $erroractionpreference
$erroractionpreference = 'stop' # quit if anything goes wrong

if (($PSVersionTable.PSVersion.Major) -lt 5)
{
    Write-Output "PowerShell 5 or greater is required to run this installer."
    Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}

$BaseURL = "https://files.fusionauth.io/products/fusionauth"
$Version = Invoke-WebRequest -UseBasicParsing -Uri https://metrics.fusionauth.io/api/latest-version
# Trim the trailing \ since we add it when we set the destination directory, and it may come back on the FullName property
#  > C:\> (Get-Item -Path ".\").FullName       => C:\
#  > C:\foo> (Get-Item -Path ".\").FullName    => C:\foo
$CurrentDirectory = (Get-Item -Path ".\").FullName.TrimEnd("\")

# Handle POSIX compliant operating systems that use the variable TMPDIR instead (i.e. macOS, Linux, Unix)
$TempDir = $env:Temp
if (!$TempDir)
{
    $TempDir = $env:TMPDIR
}

Write-Output "Install FusionAuth version ${Version}"

if (Test-Path "$CurrentDirectory\fusionauth\fusionauth-app")
{
    Remove-Item -Force -Recurse "$CurrentDirectory\fusionauth\fusionauth-app"
}
if (Test-Path "$CurrentDirectory\fusionauth\fusionauth-search")
{
    Remove-Item -Force -Recurse "$CurrentDirectory\fusionauth\fusionauth-search"
}
if (Test-Path "$CurrentDirectory\fusionauth\bin")
{
    Remove-Item -Force -Recurse "$CurrentDirectory\fusionauth\bin"
}

Write-Output "Installing zip packages"

# Install search first so that we get the search version of fusionauth.properties (which enables search)
if ($IncludeSearch)
{
    DownloadAndExpandZip "$BaseURL/$Version/fusionauth-search-$Version.zip" "$TempDir\fusionauth-search.zip" "$CurrentDirectory\fusionauth"
}
DownloadAndExpandZip "$BaseURL/$Version/fusionauth-app-$Version.zip" "$TempDir\fusionauth-app.zip" "$CurrentDirectory\fusionauth"

Write-Output ""
Write-Output "Install is complete. Time for tacos."
Write-Output ""
Write-Output " 1. To start FusionAuth run the following command"
Write-Output "    .\fusionauth\bin\startup.ps1"
Write-Output ""
Write-Output " 2. To begin, access FusionAuth by opening a browser to http://localhost:9011"
Write-Output ""
Write-Output " 3. If you're looking for documentation, open your browser and navigate to https://fusionauth.io/docs"
Write-Output ""
Write-Output "Thank you have a nice day."

# Restore old setting
$erroractionpreference = $old_erroractionpreference # Reset $erroractionpreference to original value
