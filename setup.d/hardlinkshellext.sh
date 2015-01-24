#!/bin/sh

platform=X64

cd /tmp/

[ -f "HardLinkShellExt_X64.exe" ] || \
	wget "http://schinagl.priv.at/nt/hardlinkshellext/HardLinkShellExt_${platform}.exe"

chmod +x HardLinkShellExt_${platform}.exe


HardLinkShellExt_${platform}.exe /S /Language=English

