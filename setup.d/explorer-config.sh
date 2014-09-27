#!/bin/sh


explorer="/HKCU/Software/Microsoft/Windows/CurrentVersion/Explorer"


regtool -wd set $explorer/Advanced/HideFileExt 0
regtool -wd set $explorer/Advanced/Hidden 1
regtool -wd set $explorer/Advanced/ShowSuperHidden 1

# Avoid the "Shortcut" text added to filename when creating shortcuts
regtool -wb set $explorer/link 00

policies="/HKLM/SOFTWARE/Microsoft/Windows/CurrentVersion/Policies/Explorer"

# Remove the "use Web to find correct program" option dialog for "Open With"
regtool -wd add $policies/NoInternetOpenWith
regtool -wd set $policies/NoInternetOpenWith 1


policies="/HKLM/SOFTWARE/Microsoft/Windows/CurrentVersion/Policies/System"
