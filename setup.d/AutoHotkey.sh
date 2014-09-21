#!/bin/sh

URL="http://ahkscript.org/download/ahk-u64.zip"

# Create AutoHotkey script directory if it doesn't exist already
ahkdir="$(cygpath "$APPDATA")/AutoHotkey"
[ -d "$ahkdir" ] && [ -f "$ahkdir"/main.ahk ]|| {
	echo "No AutoHotKey script directory existed, creating folder with default scripts"
	mkdir -p "$ahkdir"
	cp -r AutoHotkey/* "$ahkdir"/
}

if which AutoHotkey
then
	echo "AutoHotkey is already installed"
else
	cd /tmp/
	wget "$URL" -O ahk.zip
	yes "n" | aunpack -E -X /bin/ "ahk.zip"
	
	chmod +x /bin/*.exe
fi

echo "Setting AutoHotKey to start automatically at boot"
regtool -ws set /HKCU/Software/Microsoft/Windows/CurrentVersion/Run/AutoHotkey \
	"\"$(cygpath -w "$(which AutoHotkey)")\" \"$(cygpath -w "$ahkdir"/main.ahk)\""

#regtool -ws set /HKCR/AutoHotkeyScript/Shell/Edit/Command \
#	"\"C:\\Program Files (x86)\\Notepad++\\notepad++.exe\" \"%1\""