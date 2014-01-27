#!/bin/sh

# Create default script if it doesn't exist already
ahkscript="$USERPROFILE/Documents/AutoHotkey.ahk"
[ -f "$ahkscript" ] || cat > "$ahkscript" <<AHK

#z::Run http://ahkscript.org/docs/scripts/

LAlt & F1:: Run mintty.exe

;; WASD navigation
LWin & w::AltTab
LWin & s::ShiftAltTab

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

AHK

cd /tmp/

[ -f "ahk-u64.zip" ] || \
	wget "http://ahkscript.org/download/ahk-u64.zip"

yes "n" | aunpack -E -X /bin/ "ahk-u64.zip"

chmod +x /bin/*.exe