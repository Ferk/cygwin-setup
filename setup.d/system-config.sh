#!/bin/sh

policies="/HKLM/SOFTWARE/Microsoft/Windows/CurrentVersion/Policies/System"

# Enable verbose startup/shutdown messages
regtool -wd add $policies/VerboseStatus
regtool -wd set $policies/VerboseStatus 1

desktop="/HKCU/Control Panel/Desktop"
# Automatically end user services when the user logs off or shuts down the computer
regtool -wd set $desktop/AutoEndTasks 1
# Delay before killing user processes after click on "End Task" button in Task Manager
regtool -wd set $desktop/HungAppTimeout 1000
# Reducing menus show delay time makes the menus show faster
regtool -wd set $desktop/MenuShowDelay 8
# Reduces system waiting time before killing user processes on logoff / shutdown
regtool -wd set $desktop/WaitToKillAppTimeout 2000
# Reduces system waiting time before killing not responding services
regtool -wd set $desktop/LowLevelHooksTimeout 1000

