#!/bin/sh

cd /tmp

[ -f "SysinternalsSuite.zip" ] || \
 wget "http://download.sysinternals.com/files/SysinternalsSuite.zip"

unzip -n -d /bin/ "SysinternalsSuite.zip"

chmod +x /bin/*.exe
