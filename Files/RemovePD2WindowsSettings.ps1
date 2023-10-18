# Setup
$ProjectD2InstallPath         = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Diablo2InstallPath           = Split-Path -Path $ProjectD2InstallPath -Parent

$CompatibilityExecutables     = @("Game.exe", "Diablo II.exe", "PlugY.exe")
$ExploitProtectionExecutables = @("Game.exe", "Diablo II.exe", "PD2Launcher.exe", "Updater.exe", "PlugY.exe")
$HighPerformanceExecutables   = @("Game.exe", "Diablo II.exe")
$DefenderExclusionPaths       = @($($Diablo2InstallPath))


# Remove compatibility mode settings
foreach ($exe in $CompatibilityExecutables) {
	reg.exe Delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "$($ProjectD2InstallPath)\$($exe)" /f
}

# Remove Exploit Protection overrides
foreach ($exe in $ExploitProtectionExecutables) {    
    reg.exe Delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($exe)" /f
}

# Remove Defender exception
foreach ($path in $DefenderExclusionPaths) {
	Remove-MpPreference -ExclusionPath "$($path)"
}

# Remove Windows Graphics setting to run game in high-performance mode
foreach ($exe in $HighPerformanceExecutables) {
    reg.exe Delete "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "$($ProjectD2InstallPath)\$($exe)" /f
}
