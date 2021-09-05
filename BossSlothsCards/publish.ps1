param(
    [Parameter(Mandatory)]
    [System.String]$Version,

    [Parameter(Mandatory)]
    [ValidateSet('Debug','Release','MultiplayerDebug')]
    [System.String]$Target,
    
    [Parameter(Mandatory)]
    [System.String]$TargetPath,
    
    [Parameter(Mandatory)]
    [System.String]$TargetAssembly,

    [Parameter(Mandatory)]
    [System.String]$RoundsPath,
    
    [Parameter(Mandatory)]
    [System.String]$ProjectPath
)

# Make sure Get-Location is the script path
Push-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Test some preliminaries
("$TargetPath",
 "$RoundsPath",
 "$ProjectPath"
) | % {
    if (!(Test-Path "$_")) {Write-Error -ErrorAction Stop -Message "$_ folder is missing"}
}

# Go
Write-Host "Making for $Target from $TargetPath"

# Plugin name without ".dll"
$name = "$TargetAssembly" -Replace('.dll')

# Debug copies the dll to ROUNDS
if ($Target.Equals("Debug")) {
    Write-Host "Updating local installation in r2modman"
    
    # $plug = New-Item -Type Directory -Path "$RoundsPath\BepInEx\plugins\$name" -Force
    # Write-Host "Copy $TargetAssembly to $plug"
    Copy-Item -Path "$TargetPath\$name.dll" -Destination "C:\Users\tddeb\AppData\Roaming\r2modmanPlus-local\ROUNDS\profiles\Default\BepInEx\plugins\BossSloth-BSM" -Force
    # Copy-Item -Path "$TargetPath\$name.dll" -Destination "F:\SteamLibrary\steamapps\common\ROUNDS\BepInEx\plugins\BossSloth-BSM" -Force
}
if($Target.Equals("MultiplayerDebug")) {
    Write-Host "Updating local installation in Rounds folder for multiplayer"

    Copy-Item -Path "$TargetPath\$name.dll" -Destination "C:\Users\tddeb\AppData\Roaming\r2modmanPlus-local\ROUNDS\profiles\Default\BepInEx\plugins\BossSloth-BSM" -Force
    Copy-Item -Path "$TargetPath\$name.dll" -Destination "F:\SteamLibrary\steamapps\common\ROUNDS\BepInEx\plugins\BossSloth-BSM" -Force
    start steam://rungameid/1557740
    start F:\SteamLibrary\steamapps\common\ROUNDS\Rounds.exe
}

# Release package for ThunderStore
if($Target.Equals("Release") -and $name.Equals("BossSlothsCards")) {
    $package = "$ProjectPath\release"

    Write-Host "Packaging for ThunderStore"
    New-Item -Type Directory -Path "$package\Thunderstore" -Force
    $thunder = New-Item -Type Directory -Path "$package\Thunderstore\package"
    $thunder.CreateSubdirectory('plugins')
    Copy-Item -Path "$TargetPath\$name.dll" -Destination "$thunder\plugins\"
    Copy-Item -Path "$ProjectPath\ThunderStore\README.md" -Destination "$thunder\README.md"
    Copy-Item -Path "$ProjectPath\ThunderStore\manifest.json" -Destination "$thunder\manifest.json"
    Copy-Item -Path "$ProjectPath\ThunderStore\icon.png" -Destination "$thunder\icon.png"

    ((Get-Content -path "$thunder\manifest.json" -Raw) -replace "#VERSION#", "$Version") | Set-Content -Path "$thunder\manifest.json"


    Remove-Item -Path "$package\Thunderstore\$name.$Version.zip" -Force

    Compress-Archive -Path "$thunder\*" -DestinationPath "$package\Thunderstore\$name.$Version.zip"
    $thunder.Delete($true)
}

if($Target.Equals("Release")) {
    $package = "$ProjectPath\release"
    Copy-Item -Path "$TargetPath\$name.dll" -Destination "$package\$name.$Version.dll"
}

Pop-Location
