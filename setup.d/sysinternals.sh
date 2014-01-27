#!/bin/sh

cd /tmp

[ -f "SysinternalsSuite.zip" ] || \
 wget "http://download.sysinternals.com/files/SysinternalsSuite.zip"

yes "n" | aunpack -E -X /bin/ "SysinternalsSuite.zip"

chmod +x /bin/*.exe
