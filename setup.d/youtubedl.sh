#!/bin/sh

URL=https://yt-dl.org/downloads/2014.02.05/youtube-dl.exe


if which youtube-dl
then
	echo "youtube-dl is already installed!"
else
	cd /bin/
	wget --no-check-certificate "$URL"
	chmod +x /bin/*.exe
fi
