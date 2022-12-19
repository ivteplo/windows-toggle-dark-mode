# windows-toggle-dark-mode
A simple script for toggling dark mode on Windows

## How to use it
1. First, clone this repository
```bash
git clone https://github.com/ivteplo/windows-toggle-dark-mode
```

2. Navigate to the folder of the project
```bash
cd windows-toggle-dark-mode
```

3. You can use this script directly. By default, `ToggleAppTheme` is enabled and `ToggleSystemTheme` is disabled.
```pwsh
.\toggle-dark-mode.ps1 -ToggleAppTheme:$true -ToggleSystemTheme:$false
```

4. You can add a shortcut to your desktop and/or to the start menu. To do so, specify parameters to pass to the `toggle-dark-mode` script and where to add a shortcut. For adding a shortcut to the start menu, you need administrative rights.
```pwsh
.\install.sh # by default, tries to add a shortcut to the start menu. The shortcut will have `ToggleAppTheme` enabled and `ToggleSystemTheme` disabled.
.\install.sh -ToggleSystemTheme -ToggleAppTheme:$false # install to the start menu and toggle the system theme only
.\install.sh -AppName:"Toggle Mode" # provide a custom name for the shortcut
.\install.sh -AddDesktopShortcut -AddToStartMenu:$false # add a shortcut to the desktop only
```

5. If you have added a shortcut to the start menu and want to remove it, you can run the `Uninstall Toggle Dark Mode` shortcut from the start menu.

6. If you have added a shortcut to the desktop and you want to remove it, simply delete it.
