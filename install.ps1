# Copyright (c) 2022 Ivan Teplov

param(
    [switch]$AddDesktopShortcut = $false,
    [switch]$AddToStartMenu = $true,
    [switch]$ToggleAppTheme= $true,
    [switch]$ToggleSystemTheme= $false,
    [string]$AppName = "Toggle Dark Mode"
)

try {
    $TestAppNamePath = Join-Path $env:TMP $AppName
    $unused = mkdir $TestAppNamePath -Force

    if (!(Test-Path $TestAppNamePath)) {
        throw "Invalid app name"
    }
} catch {
    echo "Invalid app name"
    exit 1
}

rmdir $TestAppNamePath

if ($AddToStartMenu) {
    $CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $IsAdmin = $CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (!$IsAdmin) {
        echo "You need admin rights to add a shortcut to the start menu"
        exit 1
    }
}

$FilePath = Join-Path $PSScriptRoot "toggle-dark-mode.ps1"
$PowerShellCommand = "powershell"

if ($(pwsh --version)) {
    $PowerShellCommand = "pwsh"
}

$PowerShellArguments = "-NoProfile -File $FilePath -ToggleAppTheme:`$$ToggleAppTheme -ToggleSystemTheme:`$$ToggleSystemTheme"

$StartMenuFolderPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\$AppName"
$StartMenuShortcutPath = Join-Path $StartMenuFolderPath "$AppName.lnk"
$StartMenuUninstallShortcutPath = Join-Path $StartMenuFolderPath "Uninstall $AppName.lnk"

if ($AddToStartMenu) {
    mkdir $StartMenuFolderPath -Force
}

$DesktopShortcutPath = Join-Path $env:HOMEPATH "Desktop\$AppName.lnk"
$IconLocation = Join-Path $env:SYSTEMROOT "System32\SHELL32.dll"
$UninstallIconIndex = 0
$IconIndex = 174

$Paths = @()
if ($AddDesktopShortcut) {
    $Paths += ,$DesktopShortcutPath
}

if ($AddToStartMenu) {
    $Paths += ,$StartMenuShortcutPath
}

$Shell = New-Object -ComObject ("WScript.Shell")

foreach ($ShortcutPath in $Paths) {
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = "cmd"
    $Shortcut.Arguments = "/c `"$PowerShellCommand $PowerShellArguments`""

    # Make it run minimized
    $Shortcut.WindowStyle = 7
    $Shortcut.IconLocation = "$IconLocation, $IconIndex"
    $Shortcut.Save()
}

if ($AddToStartMenu) {
    $Shortcut = $Shell.CreateShortcut($StartMenuUninstallShortcutPath)
    $Shortcut.TargetPath = "cmd"
    $Shortcut.Arguments = "/c `"del /s /q ^`"$StartMenuFolderPath^`"`""

    # Make it run minimized
    $Shortcut.WindowStyle = 7
    $Shortcut.IconLocation = "$IconLocation, $UninstallIconIndex"
    $Shortcut.Save()

    # Run as admin
    # (Taken from https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell)
    $Bytes = [System.IO.File]::ReadAllBytes($StartMenuUninstallShortcutPath)
    $Bytes[0x15] = $Bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
    [System.IO.File]::WriteAllBytes($StartMenuUninstallShortcutPath, $Bytes)
}

