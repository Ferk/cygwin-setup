#!/bin/sh

exit
url="http://downloads.sourceforge.net/project/sevenzip/7-Zip/9.22/7z922-x64.msi?use_mirror=optimate"
extras_url="https://7-zip.googlecode.com/files/7z-extra-922.7z"

if which 7z
then
	echo "This sotware is already installed!"
else
	wget "$url" -O /tmp/7zip.msi

	msiexec /i $(cygpath /tmp/7z.msi) /quiet /qn /norestart /log 7z.log

	# See http://sevenzip.sourceforge.jp/chm/cmdline/switches/sfx.htm
	wget "$extras_url"
fi

