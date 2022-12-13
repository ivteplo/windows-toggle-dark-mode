# Copyright (c) 2022 Ivan Teplov

param (
    [switch]$ToggleAppTheme= $true,
    [switch]$ToggleSystemTheme= $false
)

$registryItemPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

if ($ToggleAppTheme) {
    $isInLightTheme = (Get-ItemProperty -Path $registryItemPath).AppsUseLightTheme
    $useLightTheme = $isInLightTheme ? 0 : 1
    Set-ItemProperty -Path $registryItemPath -Name AppsUseLightTheme -Value $useLightTheme
}

if ($ToggleSystemTheme) {
    $isInLightTheme = (Get-ItemProperty -Path $registryItemPath).SystemUsesLightTheme
    $useLightTheme = $isInLightTheme ? 0 : 1
    Set-ItemProperty -Path $registryItemPath -Name SystemUsesLightTheme -Value $useLightTheme
}
