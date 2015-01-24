

function exitmsg($exitcode, $msg, $color) {
	if(!$color) {
		$color = @{$true="green";$false="red"}[$exitcode -eq 0]
	}
	Write-Host "`n" $msg "`n Press any key to exit ..." -ForegroundColor $color -BackgroundColor black
	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	exit $exitcode
}

try {
	choco version
} catch {
	try {
		iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
	} catch {
		exitmsg 1 "Couldn't install Chocolatey."
	}
}

$chocopkgs = "cygwin", "cyg-get", "sudo", "sysinternals"
$chocopkgs += "7zip", "windirstat", "webpicmd", "notepadplusplus", "autohotkey", "LinkShellExtension", "youtube-dl"

$cygwinpkgs = "chere", "cygutils", "cygutils-extra", "wget", "atool", "unzip", "git", "shutdown", "nosleep", "ncdu", "openssh"

try {
	choco install $chocopkgs
	choco install $cygwinpkgs -source cygwin
} catch {
	exitmsg 1 "Error installing packages"
}


# Cygwin-specific setup will run in a separate bash terminal
try {
echo @'

	echo
	echo ' * Checking cygwin HOME folder'
	echo
	if mount -m | grep "/home/$USERNAME "
	then
		echo "$HOME is already a mountpoint"
	else
		echo "Setting up cygwin HOME ($HOME) as a mountpoint to '$USERPROFILE'"
		echo mount -f "$(cygpath "$USERPROFILE")" ~
		echo mount -m > /etc/fstab
	fi
	
	echo
	echo ' * Fetching cygwin-setup data'
	echo
	mkdir -p ~/.local/cygwin
	( cd ~/.local/cygwin
		if [ -e .git ]
		then
			git pull
		else
			git clone https://github.com/Ferk/cygwin-setup .
		fi
		
		echo " ** Applying registry files"
		regedit.exe /s setup.d/regfiles/*.reg
	)
	
	echo
	echo ' * Setting up XDG_CONFIG'
	echo
	mkdir -p ~/.config
	( cd ~/.config
		if [ -e .git ]
		then
			git pull
		else
			mkdir -p "../old-xdg-config"
			mv * "../old-xdg-config"
			rmdir "../old-xdg-config" || \
				echo "A Backup directory was created with the old settings"
			
			git clone https://github.com/Ferk/xdg_config .
			./symlink.sh
		fi
	)
	
	echo
	echo ' * Adding a "Bash prompt here" on context menu of folders'
	echo
	chere -im -t mintty
'@ | bash
}
catch {
	exitmsg 1 "Error during cygwin setup"
}


exitmsg 0 "Installation finished successfully"