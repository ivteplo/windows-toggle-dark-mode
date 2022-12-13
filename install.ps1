#Requires -RunAsAdministrator
# Copyright (c) 2022 Ivan Teplov

param(
    [switch]$AddDesktopShortcut = $false,
    [switch]$AddToStartMenu = $true
)

$FilePath = Join-Path $PSScriptRoot "toggle-dark-mode.ps1"
$StartMenuShortcutPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Toggle dark mode.lnk"
$DesktopShortcutPath = Join-Path $env:HOMEPATH "Desktop\Toggle dark mode.lnk"
$IconLocation = Join-Path $env:SYSTEMROOT "System32\SHELL32.dll"
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
    $Shortcut.TargetPath = $FilePath
    $Shortcut.IconLocation = "$IconLocation, $IconIndex"
    $Shortcut.Save()
}

