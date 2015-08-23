
/**
 * Tray menu subroutines
 */

;; We'll use our own menu
Menu, Tray, Tip, Mouse Gestures
Menu, Tray, Icon, %A_ScriptDir%/icon.ico, , 1
Menu, Tray, NoStandard ; remove standard Menu items

;; Tool Menu
Menu, AdminMenu, add, Edit /etc/hosts file, Menu_editHosts
Menu, AdminMenu, add, regedit, Menu_runThisItem
Menu, AdminMenu, add

Loop, Files, %A_ScriptDir%/scripts/*.ps1
   Menu, AdminMenu, add, %A_LoopFileName%, Menu_runThisItemScript
   
Menu, AdminMenu, add
Menu, AdminMenu, add, msconfig, Menu_runThisItem
Menu, AdminMenu, add, msinfo32, Menu_runThisItem
Menu, AdminMenu, add, verifier, Menu_runThisItem
Menu, AdminMenu, add, devmgmt.msc, Menu_runThisItem
Menu, AdminMenu, add, control printers, Menu_runThisItem
Menu, AdminMenu, add, control netconnections, Menu_runThisItem
Menu, AdminMenu, add, control schedtasks, Menu_runThisItem
Menu, AdminMenu, add, control userpasswords2, Menu_runThisItem
Menu, AdminMenu, add, control admintools, Menu_runThisItem

;; Main Tray menu
Menu, Tray, add
Menu, Tray, add, Shutdown Timer, Menu_shutdownTimer
Menu, Tray, Add, Magnifier, Menu_runThisItemAhk
Menu, Tray, Add, WindowKill, Menu_runThisItemAhk
Menu, tray, add
Menu, tray, add, Run on Startup, Menu_ToggleStartup
Menu, Tray, Add, Admin Tools, :AdminMenu
Menu, Tray, Add
Menu, Tray, Add, Open scripts folder, Menu_openScriptDir
Menu, tray, add, Window Spy, Menu_windowSpy
Menu, Tray, Add, R&eload, Menu_Reload
Menu, Tray, Add
Menu, Tray, Add, E&xit, Menu_Exit


; Determine whether this script is set to run at startup
StartupCommandline = %A_AhkPath% %A_ScriptFullPath%
RegRead, StartupRegistry, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, AutoHotkey

if(StartupRegistry == StartupCommandline) {
	menu, tray, Check, Run on Startup
}
 else {
	menu, tray, UnCheck, Run on Startup
}
VarSetCapacity(StartupRegistry, 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;



Menu_Reload:
    Reload
	return

Menu_Exit:
	ExitApp

Menu_shutdownTimer:
	InputBox, args, Shutdown Timer, Enter the arguments for the shutdown command. Time (/t) must be in seconds. Specify at least one of:`n /s For shutdown.`n /r For reboot.`n /h For hibernation.`n /a For aborting, , 340, 240, , , , ,/m \\localhost /s /t 3600
	if not ErrorLevel
		Run shutdown %args% , , Hide UseErrorLevel
		if ErrorLevel = ERROR
			MsgBox ERROR: %A_LastError%
	return

Menu_editHosts:
	G_EditFile(SYSTEMROOT "\System32\Drivers\etc\hosts")
	return

Menu_runThisItem:
	Run %A_ThisMenuItem%
	return

Menu_runThisItemScript:
	Run powershell -Command & '%A_ScriptDir%/scripts/%A_ThisMenuItem%'
	return
	
Menu_runThisItemAhk:
	Run "%A_AhkPath%" "%A_ScriptDir%\%A_ThisMenuItem%.ahk"
	return

Menu_openScriptDir:
	Run %A_ScriptDir%
	return

Menu_windowSpy:
	Run "%A_ProgramFiles%\AutoHotKey\AU3_Spy.exe"
	return


Menu_ToggleStartup:
	RegRead, StartupRegistry, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, AutoHotkey
	if(StartupRegistry == StartupCommandline) {
		RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, AutoHotkey
		isStartupEnabled = false
		menu, %A_ThisMenu%, UnCheck, %A_ThisMenuItem%
	}
	else {
		RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, AutoHotkey, %StartupCommandline%
		isStartupEnabled = true
		menu, %A_ThisMenu%, Check, %A_ThisMenuItem%
	}
	return

;TrayMenu_Open:
    ; DetectHiddenWindows, On
    ; Process, Exist
;    PostMessage, 0x111, 65300,,, ahk_class AutoHotkey ahk_pid %ErrorLevel%
; return

;TrayMenu_Suspend:
;    gosub ToggleGestureSuspend
; return
TrayMenu_Edit:
    G_EditFile(A_ScriptDir "\" RegExReplace(A_ThisMenuItem,"^Edit |&"))
	return


G_EditFile(file)
{
    Run edit %file%,, UseErrorLevel
    if ErrorLevel = ERROR
        Run, open "%file%"
}
