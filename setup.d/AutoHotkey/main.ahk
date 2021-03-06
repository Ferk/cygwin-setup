
#Include %A_ScriptDir%              ; Set working directory for #Include.
;#Include *i gestures.ahk
#Include *i tray.ahk
#Include *i alt_drag_window.ahk

SoundPlay, *48

#SingleInstance force

;; ------------------------
;; ---- Window Groups -----

;; Create a group for easy identification of Windows Explorer windows.
GroupAdd, Explorer, ahk_class CabinetWClass
GroupAdd, Explorer, ahk_class ExploreWClass

; Gesture_D_R never closes these windows:
; GroupAdd, CloseBlacklist, ahk_class Progman         ; Desktop
; GroupAdd, CloseBlacklist, ahk_class Shell_TrayWnd   ; Taskbar

;; -------------------------
;; -- General Keybindings --

;; Do not use them for Source Engine or Unreal engine games (we need to use ahk_class, ahk_group only groups windows open at launch)
#if (!WinActive("ahk_class Valve001") && !WinActive("ahk_class SDL_app") && !WinActive("ahk_class LaunchUnrealUWindowsClient"))

#z::Run http://ahkscript.org/docs/scripts/

LAlt & F1:: Run "mintty.exe", %USERPROFILE%

;; Toggle AlwaysOnTop for the currently selected window
#t::
	WinGet, currentWindow, ID, A
	WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
	if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
	{
		Winset, AlwaysOnTop, off, ahk_id %currentWindow%
		SplashImage,,b cwffffff ct808080, Always on Top: OFF.
		Sleep, 500
		SplashImage, Off
	}
	else
	{
		WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
		SplashImage,,b cwffffff ct000080, Always on Top: ON.
		Sleep, 500
		SplashImage, Off
	}
	return

;; WASD navigation


LAlt & w::
	if(!isTaskViewOpen) {
		SendEvent #{Tab}
		Sleep, 100
		isTaskViewOpen := true
	}
	SendEvent {Right}
	return

LAlt & s::
	if(!isTaskViewOpen) {
		SendEvent #{Tab}
		Sleep, 100
		isTaskViewOpen := true
	}
	SendEvent {Left}
	return

LAlt & w Up::
	if(!isWaitingForRelease) {
		isWaitingForRelease := true
		while(GetKeyState("LAlt","P")) {
			Sleep 100
		}
		Send {Enter}
		isTaskViewOpen := false
		isWaitingForRelease := false
	}
	return

LAlt & s Up::
	if(!isWaitingForRelease) {
		isWaitingForRelease := true
		while(GetKeyState("LAlt","P")) {
			Sleep 100
		}
		Send {Enter}
		isTaskViewOpen := false
		isWaitingForRelease := false
	}
	return
	
LAlt & d::
	SendEvent ^#{Right}
	return
	
LAlt & a::
	SendEvent ^#{Left}
	return
	
; ^!n::
	; IfWinExist Untitled - Notepad
		; WinActivate
	; else
		; Run Notepad
	; return


; Ctrl+Alt+C - Toggle autoclick
^!c::
	autocliking := !autoclicking
	SendMode Input
	Loop
	{
		if (!autoclicking) {
			break
		}
		Click
	}
    return
	
; #InstallKeybdHook

; #InstallMouseHook

; ~WheelUp::
	; if (A_TimeSincePriorHotkey > 75)
	; {
		; return
	; }
	; Send {WheelUp 3}
	; return

; ~WheelDown::
	; if (A_TimeSincePriorHotkey > 75)
	; {
		; return
	; }
	; Send {WheelDown 3}
	; return


; Only run when Windows Explorer is active
#IfWinActive Explorer
 
; Ctrl+Alt+H - Toggle hidden files
^!h::
    RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
    If HiddenFiles_Status = 2
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
    Else
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
    Send, {F5}
    Return
 
; Ctrl+Alt+E - Toggle extensions
^!e::
    RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
    If HiddenFiles_Status = 1
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
    Else
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
    Send, {F5}
    Return
 
#IfWinActive

;; ----------------------
;; ------ Gestures ------


; Gesture_L:
    ; SetTitleMatchMode, RegEx
    ; if WinActive("ahk_group ^Explorer$")
        ; Send !{Left}
    ; else if WinActive("- (Microsoft )?Visual C\+\+")
        ; Send ^-
    ; else if WinActive("ahk_class ^#32770$") && G_ControlExist("SHELLDLL_DefView1")
        ; ; Possibly a File dialog, so try sending "Back" command.
        ; SendMessage, 0x111, 0xA00B ; WM_COMMAND, ID
    ; else
        ; Send {Browser_Back}
    ; return

; Gesture_R:
    ; SetTitleMatchMode, RegEx
    ; if WinActive("ahk_group ^Explorer$")
        ; Send !{Right}
    ; else if WinActive("- (Microsoft )?Visual C\+\+")
        ; Send ^+-
    ; else
        ; Send {Browser_Forward}
    ; return


; ; Close Application (or Firefox tab) - down, then right
; Gesture_D_R:
    ; ifWinActive, ahk_group CloseBlacklist
        ; return

    ; ; close previously minimized window for good
    ; if m_ClosingWindow
        ; gosub gdCheckCloseApp

    ; ; remember ID of window
    ; m_ClosingWindow := WinActive("A")

    ; if m_ClosingWindow
    ; {
        ; WinMinimize ; deactivate the window, reactivating next window down in the z-order
        ; WinHide ; hide window
        ; ; give 3 second delay before actually closing
        ; SetTimer, gdCloseApp, 3000
        ; ; allow the Escape key to cancel (and show the window again)
        ; Hotkey, Escape, gdCancelCloseApp, On
    ; }
; return

; gdCloseApp:
    ; ; disable timer and cancel hotkey
    ; SetTimer, gdCloseApp, Off
    ; Hotkey, Escape, gdCancelCloseApp, Off

; gdCheckCloseApp:
    ; if m_ClosingWindow
    ; {
        ; DetectHiddenWindows, Off
        ; ; don't close the window if it is visible
        ; ; (for example, user may have pressed a hotkey causing the m_ClosingWindow to be shown before it closes)
        ; if (! WinExist("ahk_id " m_ClosingWindow))
        ; {
            ; DetectHiddenWindows, On
            ; WinClose, ahk_id %m_ClosingWindow%
            ; DetectHiddenWindows, Off
        ; }
        ; m_ClosingWindow := 0
    ; }
; return

; ; Press Escape within 3 seconds to cancel "Close App"
; gdCancelCloseApp:
    ; ; disable timer and hotkey
    ; SetTimer, gdCloseApp, Off
    ; Hotkey, Escape, gdCancelCloseApp, Off

    ; ; show the window again
    ; WinShow, ahk_id %m_ClosingWindow%
    ; WinActivate, ahk_id %m_ClosingWindow%
    ; m_ClosingWindow := 0

    ; ; play a sound
    ; SoundPlay, *-1
; return



; Gesture_L_D:    ; Minimize
    ; G_MinimizeActiveWindow()
    ; return
; Gesture_R_U:    ; Maximize
    ; PostMessage, 0x112, 0xF030, , , A ; WM_SYSCOMMAND, SC_MAXIMIZE
    ; return

; Gesture_R_L:
; Gesture_L_R:
    ; WinGet, mm, MinMax, A
    ; if ((lastMinTime+2000 > A_TickCount && WinExist("ahk_id " lastMinID))   ; undo recent minimize
        ; OR (mm && WinActive("A"))                                           ; active window is minimized or maximized, restore it
        ; OR WinExist(G_GetLastMinimizedWindow()))                            ; restore "top-most" minimized window
    ; {
        ; ; PostMessage, WM_SYSCOMMAND, SC_RESTORE  ; -- restores the window, playing relevant "Restore" sound
        ; PostMessage, 0x112, 0xF120
        ; lastMinTime = 0
        ; lastMinID = 0
    ; }
    ; return

; Gesture_L_D_U:
; Gesture_U_L_D_U: ; <-- compensate for bad habit
    ; if WinExist(G_GetLastMinimizedWindow())
        ; PostMessage, 0x112, 0xF120
    ; return

; Gesture_R_L_R_L:
; Gesture_L_R_L_R:
    ; WinActive("A")
    ; WinGet, mm, MinMax
    ; if mm
        ; SendMessage, 0x112, 0xF120 ; WM_SYSCOMMAND, SC_RESTORE
    ; PostMessage, 0x112, 0xF010 ; WM_SYSCOMMAND, SC_MOVE
    ; Send {Left}{Right}
    ; return
