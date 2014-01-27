#!/bin/sh

VERSION="6.5.3"

cd /tmp/

[ -f "npp.$VERSION.Installer.exe" ] || \
	wget "http://download.tuxfamily.org/notepadplus/$VERSION/npp.$VERSION.Installer.exe"

chmod +x npp.$VERSION.Installer.exe
	
./npp.$VERSION.Installer.exe /S
