#!/bin/sh

URL=https://yt-dl.org/downloads/2014.02.05/youtube-dl.exe

cd /bin/
wget --no-check-certificate "$URL"
chmod +x /bin/*.exe

