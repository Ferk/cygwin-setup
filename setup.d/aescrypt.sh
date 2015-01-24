#!/bin/sh

URL=https://www.aescrypt.com/download/v3/windows/AESCrypt_v309_x64.zip

if which aescrypt
then
	echo "aescrypt is already installed!"
else

	if -ne $PROGRAMFILES/AESCrypt/aescrypt.exe
		echo "AESCrypt not installed! downloading..."
		cd /tmp/
		wget "$url" -O aescrypt-install.zip
		unp aescrypt-install.zip

		msiexec /i $(cygpath AESCrypt*/AESCrypt.msi) /quiet /qn /norestart /log AESCrypt.log
		rm
	fi

	echo "Adding AESCRYPT script to PATH" cat >/bin/aescrypt  <<EOF
	#!/bin/sh
	exec $PROGRAMFILES/AESCrypt/aescrypt.exe "$@"
EOF
	chmod +x /bin/aescrypt

fi
