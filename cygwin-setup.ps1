

function exitmsg($exitcode, $msg, $color) {
	if(!$color) {
		$color = @{$true="green";$false="red"}[$exitcode -eq 0]
	}
	Write-Host "`n" $msg "`n Press any key to exit ..." -ForegroundColor $color -BackgroundColor black
	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	exit $exitcode
}

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    exitmsg 1 "You need Administrator rights to run this script!"
}

try {
	if(Get-Command choco -errorAction SilentlyContinue) {
		echo "Chocolatey binary found. Checking whether it's the latest version."
		choco update
		choco upgrade -y chocolatey
	}
	else {
		echo "Installing Chocolatey."
		iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
		Get-Command choco
		choco update
	}
} catch {
	exitmsg 1 "Error installing or updating Chocolatey."
}

# TODO: readd packages when fixed upstream: sudo cyg-get

$chocopkgs = "cygwin", "sysinternals"
$chocopkgs += "7zip", "windirstat", "webpicmd", "notepadplusplus", "autohotkey", "LinkShellExtension", "youtube-dl", "nmap"

$cygwinpkgs = "chere", "cygutils", "cygutils-extra", "wget", "atool", "unzip", "git", "shutdown", "nosleep", "ncdu", "openssh"

try {
	choco install -y $chocopkgs
	# TODO: use next line instead of the try-catch when chocolatey has a proper way to install cygwin packages
	# choco install -y $cygwinpkgs -source cygwin
	try {
		$cygRoot = (Get-ItemProperty HKLM:\SOFTWARE\Cygwin\setup -Name rootdir).rootdir
    		$cygwinsetup = Get-Command $cygRoot"\cygwinsetup.exe"
    		$cygLocalPackagesDir = join-path $cygRoot packages
    		$cygInstallPackageList = ($cygwinpkgs -join ",")
    		Write-Host "Attempting to install cygwin packages: $cygInstallPackageList"
    		Start-Process "$cygwinsetup" "-q -N -R $cygRoot -l $cygLocalPackagesDir -P $cygInstallPackageList" -Wait -NoNewWindow
  	}
  	catch {
    		Write-Error "Please ensure you have cygwin installed (with chocolatey). To install please call 'cinst cygwin'. ERROR: $($_.Exception.Message)"
  	}
} catch {
	exitmsg 1 "Error installing packages"
}

try {
	$cygRoot = (Get-ItemProperty HKLM:\SOFTWARE\Cygwin\setup -Name rootdir).rootdir
	if( -not ( $env:Path -like "*${cygRoot}\bin*" ) ) {
		echo " ** Adding ${cygRoot}\bin to Windows Path"
		$env:Path += ";$cygRoot\bin"
		[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path, "Machine")
	}
} catch {
	exitmsg 1 "Error setting up the environment"
}

# Cygwin-specific setup will run in a separate bash terminal
try {
	if( -not {bash --version}) {
		exitmsg 1 "Couldn't find 'bash' in Windows PATH: $env:Path"
	}
	echo @'

	echo
	echo ' * Checking cygwin HOME folder'
	echo
	if mount -m | grep "/home/$USERNAME "
	then
		echo "$HOME is already a mountpoint"
	else
		echo " ** Setting up cygwin HOME ($HOME) as a mountpoint to '$USERPROFILE'"
		mount -f "$USERPROFILE" "/home/$USERNAME"
		mount -m >/etc/fstab
	fi
	
	echo
	echo ' * Setting up CYGWIN environment variable'
	echo
	if [ -e /etc/profile.d/cygwin_env.sh ]
	then
		echo " ** There's already a profile.d script for setting \$CYGWIN:"
		cat /etc/profile.d/cygwin_env.sh
	else
		export CYGWIN="winsymlinks:native"
		tee /etc/profile.d/cygwin_env.sh <<EOF
#!/bin/sh
export CYGWIN='$CYGWIN'
# Make sure the /bin folder is the first in the PATH, taking precedence over WINDOWS binaries
export PATH="/bin:\$PATH"

alias cygg='cyg-get.bat'
alias cygp='cygpath'
alias xdg-open='cmd /C start "" '
EOF
	fi
		
	echo
	echo ' * Fetching cygwin-setup data'
	echo
	mkdir -p ~/.local/cygwin
	( cd ~/.local/cygwin
		if [ -e .git ]
		then
			echo ' ** A repository already exists for cygwin-setup. Updating...'
			git pull
		else
			git clone https://github.com/Ferk/cygwin-setup .
		fi
		if [ -d regfiles ]
		then
			echo " ** Applying registry files"
			regedit.exe /s regfiles/*.reg
		else
			echo " !!!! ERROR FETCHING CYGWIN-SETUP !!!!"
		fi
	)
	
	echo
	echo ' * Setting up XDG_CONFIG'
	echo
	
	if [ -d ~/.config ] && ! [ -e ~/.config/.git ]
	then
		mv ~/.config ~/"old-xdg-config"
		rmdir ~/"old-xdg-config" || \
			echo " ** A Backup directory was created with the old settings"
	fi
	
	if [ -e ~/.config/.git ]
	then
		( cd ~/.config && git pull )
	else
		git clone https://github.com/Ferk/xdg_config ~/.config
		
		if [ -e ~/.config/symlink.sh ]
		then
			~/.config/symlink.sh
		else
			echo " !!!! ERROR FETCHING XDG-CONFIG !!!!"
		fi
	fi
	
	echo
	echo ' * Adding a "Bash prompt here" on context menu of folders'
	echo
	chere -im -t mintty

	echo Done running cygwin bash setup
'@ | bash
}
catch {
	exitmsg 1 "Error during cygwin setup"
}


exitmsg 0 "Installation finished successfully"
