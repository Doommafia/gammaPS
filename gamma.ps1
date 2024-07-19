# marker file
$markerFilePath = "C:\dev\GammaMarker.txt"

# paths for nvcplui.exe
$directories = @(
    "C:\Program Files\NVIDIA Corporation\Control Panel Client",
    "C:\Program Files (x86)\NVIDIA Corporation\Control Panel Client",
    "C:\Program Files\NVIDIA Corporation",
    "C:\Program Files (x86)\NVIDIA Corporation"
)

# look for nvcplui
$executableFound = $false
foreach ($dir in $directories) {
    if (Test-Path $dir) {
        # Get the first matching file
        $result = Get-ChildItem -Path $dir -Filter "nvcplui.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($result) {
            $nvcpluiPath = $result.FullName
            $executableFound = $true
            break
        }
    }
}

function load_NVIDIA_profile {
    param (
        [string]$profileName,
        [string]$nvcpluiPath
    )
    if ($nvcpluiPath) {
        Start-Process $nvcpluiPath -ArgumentList "-loadProfile $profileName"
    } else {
        Write-Output "NVIDIA Control Panel executable not found. Cannot load profile."
    }
}

if ($executableFound) {
    if (Test-Path $markerFilePath) {
        load_NVIDIA_profile "Gamma1" $nvcpluiPath
        Remove-Item $markerFilePath
        Write-Output "Gamma has been set to 1.0"
    } else {
        load_NVIDIA_profile "Gamma1_5" $nvcpluiPath
        New-Item -ItemType File -Path $markerFilePath
        Write-Output "Gamma has been set to 1.5"
    }
} else { Write-Output "No executable found." }
