#!/bin/sh

if which tclkit
then
	echo "tclkit is already installed!"
else
	wget --no-check-certificate "https://tclkit.googlecode.com/files/tclkitsh-8.5.9-win32.upx.exe" \
		-O /bin/tclkitsh.exe
	wget --no-check-certificate "https://tclkit.googlecode.com/files/tclkit-8.5.9-win32.upx.exe" \
		-O /bin/tclkit.exe
	
	chmod +x /bin/tclkit*.exe
fi
