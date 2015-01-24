#!/bin/sh

URL="http://downloads.sourceforge.net/project/ssubs/%5BS%5D-Subs%200.14%20Win32.zip?use_mirror=optimate"

if which SSubs
then
	echo "youtube-dl is already installed!"
else
	wget --no-check-certificate "$URL" -O /tmp/ssubs.zip
	unzip -jd/bin/ /tmp/ssubs.zip "*/*.exe"
	chmod +x /bin/SSubs.exe
fi

