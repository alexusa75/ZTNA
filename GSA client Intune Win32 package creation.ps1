
############################################
#  Create GSA Client Intune Win32 package  #
############################################


$downloadUrl = "https://aka.ms/GSAClientDownload"
$destinationFolder = [Environment]::GetFolderPath("Desktop") + "\GSAClient"


# Check if the destination folder exists, create it if it doesn't
if (-not (Test-Path -Path $destinationFolder -PathType Container)) {
    New-Item -Path $destinationFolder -ItemType Directory | Out-Null
}

# Set the destination file path
$destinationFile = Join-Path -Path $destinationFolder -ChildPath "GlobalSecureAccessClient.exe"

try{
    # Download the GSA Client
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($downloadUrl, $destinationFile)

    Write-Host "Client downloaded and saved to $destinationFile." -ForegroundColor Yellow
}catch{
    Write-Host "Error downloading the GSAClient: $($_.Exception.Message)" -ForegroundColor Red
    exit
}

try{
    # Download the IntuneWinAppUtil
    $IntuneWinApp = "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/raw/master/IntuneWinAppUtil.exe"
    $destinationFileIntuneWinApp = Join-Path -Path $destinationFolder -ChildPath "IntuneWinAppUtil.exe"
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($IntuneWinApp, $destinationFileIntuneWinApp)

    Write-Host "IntuneWinApp downloaded and saved to $destinationFile." -ForegroundColor Yellow
}catch{
    Write-Host "Error downloading the IntuneWinAppUtil: $($_.Exception.Message)" -ForegroundColor Red
    exit
}


try{
    #Creating the Win32App package
    cd $destinationFolder
    ./IntuneWinAppUtil.exe -c $destinationFolder -s $destinationFile -o $destinationFolder

    Write-Host "The Win32 package was crated successfully, you can find it in $($destinationFolder)\GlobalSecureAccessClient.intunewin"
}catch{
    Write-Host "Error downloading the IntuneWinAppUtil: $($_.Exception.Message)" -ForegroundColor Red
    exit
}
