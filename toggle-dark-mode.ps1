# Copyright (c) 2022 Ivan Teplov

$registry_item_path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

$is_in_light_mode = (Get-ItemProperty -Path $registry_item_path).AppsUseLightTheme
$use_light_mode = $is_in_light_mode ? 0 : 1
Set-ItemProperty -Path $registry_item_path -Name AppsUseLightTheme -Value $use_light_mode

