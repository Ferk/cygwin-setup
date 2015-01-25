
/**
 * Tray menu subroutines
 */


;; Tool Menu
Menu, ToolMenu, add, Shutdown Timer, Menu_shutdownTimer
Menu, ToolMenu, add, Edit /etc/hosts file, Menu_editHosts
Menu, ToolMenu, add, regedit, Menu_runThisItem
Menu, ToolMenu, add
Menu, ToolMenu, add, msconfig, Menu_runThisItem
Menu, ToolMenu, add, msinfo32, Menu_runThisItem
Menu, ToolMenu, add, verifier, Menu_runThisItem
Menu, ToolMenu, add, devmgmt.msc, Menu_runThisItem
Menu, ToolMenu, add, control printers, Menu_runThisItem
Menu, ToolMenu, add, control netconnections, Menu_runThisItem
Menu, ToolMenu, add, control schedtasks, Menu_runThisItem
Menu, ToolMenu, add, control userpasswords2, Menu_runThisItem
Menu, ToolMenu, add, control admintools, Menu_runThisItem

;; Main system tray menu
Menu, Tray, Tip, Mouse Gestures
;Menu, Tray, NoStandard
Menu, tray, add
Menu, Tray, Add, WindowKill, Menu_runThisItemScript
Menu, tray, add
Menu, tray, add, Run on Startup, Menu_ToggleStartup
Menu, Tray, Add, Admin Tools, :ToolMenu 
Menu, Tray, Add
Menu, Tray, Add, Open scripts folder, Menu_openScriptDir
Menu, Tray, Add, R&eload, Menu_Reload
Menu, tray, add  
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


MenuHandler:
MsgBox You selected %A_ThisMenuItem% from menu %A_ThisMenu%.
return
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
	Run "%A_AhkPath%" "%A_ScriptDir%\%A_ThisMenuItem%.ahk"
	return
	
Menu_openScriptDir:
	Run %A_ScriptDir%
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