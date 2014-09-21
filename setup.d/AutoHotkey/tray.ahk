
/*
 * Tray menu subroutines
 */

 
; Set tooltip for tray icon.
Menu, Tray, Tip, Mouse Gestures

; Setup custom tray menu.
Menu, Tray, NoStandard
Menu, Tray, Add, &Open      , TrayMenu_Open
Menu, Tray, Add, &Help      , TrayMenu_Help
Menu, Tray, Add
Menu, Tray, Add, &Reload    , TrayMenu_Reload
Menu, Tray, Add, &Suspend   , TrayMenu_Suspend
Menu, Tray, Add
Menu, Tray, Add, Edit &main.ahk , TrayMenu_Edit
Menu, Tray, Add, Edit &gestures.ahk         , TrayMenu_Edit
Menu, Tray, Add, Edit &tray.ahk , TrayMenu_Edit
Menu, Tray, Add
Menu, Tray, Add, E&xit      , TrayMenu_Exit
Menu, Tray, Default, &Open


 
TrayMenu_Open:
    DetectHiddenWindows, On
    Process, Exist
    PostMessage, 0x111, 65300,,, ahk_class AutoHotkey ahk_pid %ErrorLevel%
return
TrayMenu_Help:
    MsgBox, Sorry, feature not implemented!
return
TrayMenu_Reload:
    Reload
return
TrayMenu_Suspend:
    gosub ToggleGestureSuspend
return
TrayMenu_Edit:
    G_EditFile(A_ScriptDir "\" RegExReplace(A_ThisMenuItem,"^Edit |&"))
return
TrayMenu_Exit:
ExitApp


G_EditFile(file)
{
    Run edit %file%,, UseErrorLevel
    if ErrorLevel = ERROR
        Run, open "%file%"
}