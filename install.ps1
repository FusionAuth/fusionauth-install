new-module -name FusionAuth -scriptblock {
    function Install-FusionAuth()
    {
        param (# This must come first
            [bool]$includeSearch = 0
        )

        # Get current setting
        $old_erroractionpreference = $erroractionpreference
        $erroractionpreference = 'stop' # quit if anything goes wrong

        # Try importing BitsTransfer
        if (!(Get-module BitsTransfer))
        {
            Import-Module BitsTransfer -ErrorAction SilentlyContinue
        }

        if (($PSVersionTable.PSVersion.Major) -lt 5)
        {
            Write-Output "PowerShell 5 or greater is required to run this installer."
            Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
            break
        }

        function DownloadAndExpandZip($uri, $tempFile, $destination)
        {
            Write-Output "Downloading archive, destination ${destination}"

            if (Get-module BitsTransfer)
            {
                Start-BitsTransfer -Source $uri -Destination $tempFile
            }
            else
            {
                (New-Object System.Net.WebClient).DownloadFile($uri, $tempFile)
            }

            Write-Output "Expanding archive"

            if (Test-Path "$env:Temp/fusionauth")
            {
                Remove-Item -Force -Recurse "$env:Temp/fusionauth"
            }

            New-Item "$env:Temp/fusionauth" -ItemType Directory

            Expand-Archive -Path $tempFile -DestinationPath "$env:Temp/fusionauth"

            New-Item $destination -ItemType Directory -ea 0

            robocopy "$env:Temp/fusionauth" $destination /E /XC /XN /XO /NFL /NDL /NJH /NS /NC
        }

        $BASE_URL = "https://files.fusionauth.io/products/fusionauth"
        $VERSION = Invoke-WebRequest -UseBasicParsing -Uri https://metrics.fusionauth.io/api/latest-version
        # Trim the trailing \ since we add it when we set the destination directory, and it may come back on the FullName property
        #  > C:\> (Get-Item -Path ".\").FullName       => C:\
        #  > C:\foo> (Get-Item -Path ".\").FullName    => C:\foo
        $CURRENT_DIRECTORY = (Get-Item -Path ".\").FullName.TrimEnd("\")

        Write-Output "Install FusionAuth version ${VERSION}"

        if (Test-Path "$CURRENT_DIRECTORY\fusionauth\fusionauth-app")
        {
            Remove-Item -Force -Recurse "$CURRENT_DIRECTORY\fusionauth\fusionauth-app"
        }
        if (Test-Path "$CURRENT_DIRECTORY\fusionauth\fusionauth-search")
        {
            Remove-Item -Force -Recurse "$CURRENT_DIRECTORY\fusionauth\fusionauth-search"
        }
        if (Test-Path "$CURRENT_DIRECTORY\fusionauth\bin")
        {
            Remove-Item -Force -Recurse "$CURRENT_DIRECTORY\fusionauth\bin"
        }

        echo "Installing zip packages"

        # Install search first so that we get the search version of fusionauth.properties (which enables search)
        if ($includeSearch)
        {
            DownloadAndExpandZip "${BASE_URL}/${VERSION}/fusionauth-search-${VERSION}.zip" "$env:Temp\fusionauth-search.zip" "$CURRENT_DIRECTORY\fusionauth"
        }
        DownloadAndExpandZip "${BASE_URL}/${VERSION}/fusionauth-app-${VERSION}.zip" "$env:Temp\fusionauth-app.zip" "$CURRENT_DIRECTORY\fusionauth"

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
    }

    set-alias install -value Install-FusionAuth

    export-modulemember -function Install-FusionAuth -alias install
}
