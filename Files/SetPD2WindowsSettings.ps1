# Setup
$ProjectD2InstallPath         = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Diablo2InstallPath           = Split-Path -Path $ProjectD2InstallPath -Parent

$CompatibilityExecutables     = @("Game.exe", "Diablo II.exe", "PlugY.exe")
$ExploitProtectionExecutables = @("Game.exe", "Diablo II.exe", "PD2Launcher.exe", "Updater.exe", "PlugY.exe")
$HighPerformanceExecutables   = @("Game.exe", "Diablo II.exe")
$DefenderExclusionPaths       = @($($Diablo2InstallPath))


# Set compatibility mode settings
foreach ($exe in $CompatibilityExecutables) {
	reg.exe Add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "$($ProjectD2InstallPath)\$($exe)" /d "~ RUNASADMIN WINXPSP3" /f
}

# Create Exploit Protection overrides
foreach ($exe in $ExploitProtectionExecutables) {
    Set-Processmitigation -Name "$($ProjectD2InstallPath)\$($exe)" -Disable DEP,EmulateAtlThunks,ForceRelocateImages,RequireInfo,BottomUp,      `
                                                                            HighEntropy,StrictHandle,DisableWin32kSystemCalls,AuditSystemCall,  `
                                                                            DisableExtensionPoints,BlockDynamicCode,AllowThreadsToOptOut,       `
                                                                            AuditDynamicCode,CFG,SuppressExports,StrictCFG,MicrosoftSignedOnly, `
                                                                            AllowStoreSignedBinaries,AuditMicrosoftSigned,AuditStoreSigned,     `
                                                                            EnforceModuleDependencySigning,DisableNonSystemFonts,AuditFont,     `
                                                                            BlockRemoteImageLoads,BlockLowLabelImageLoads,PreferSystem32,       `
                                                                            AuditRemoteImageLoads,AuditLowLabelImageLoads,AuditPreferSystem32,  `
                                                                            EnableExportAddressFilter,AuditEnableExportAddressFilter,           `
                                                                            EnableExportAddressFilterPlus,AuditEnableExportAddressFilterPlus,   `
                                                                            EnableImportAddressFilter,AuditEnableImportAddressFilter,           `
                                                                            EnableRopStackPivot,AuditEnableRopStackPivot,EnableRopCallerCheck,  `
                                                                            AuditEnableRopCallerCheck,EnableRopSimExec,AuditEnableRopSimExec,   `
                                                                            SEHOP,AuditSEHOP,SEHOPTelemetry,TerminateOnError,                   `
                                                                            DisallowChildProcessCreation,AuditChildProcess,UserShadowStack,     `
                                                                            UserShadowStackStrictMode,AuditUserShadowStack
}

# Create Defender exception
foreach ($path in $DefenderExclusionPaths) {
	Add-MpPreference -ExclusionPath "$($path)"
}

# Set Windows Graphics to run game in high-performance mode
foreach ($exe in $HighPerformanceExecutables) {
    reg.exe Add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "$($ProjectD2InstallPath)\$($exe)" /d "GpuPreference=2;" /f
}
