@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

set CYGWIN_URL="http://cygwin.com/setup-x86_64.exe"
::set CYGWIN_URL="http://cygwin.com/setup-x86.exe"
set CYG_MIRROR="http://cygwin.mirrors.pair.com/"
set CYGWIN_DIR="C:\cygwin"
set CYGWIN_PACKAGES="aria2,atool,autossh,openssh,git";

echo *** Creating: %CYGWIN_DIR%
mkdir "%CYGWIN_DIR%"
cd "%CYGWIN_DIR%"

echo *** Fetching: %CYGWIN_URL%
:: Using bitsadmin might have been more elegant, but it's a deprecated command :(
:: Also, while it could have been possible to write the whole thing as a powershell script,
:: since you can't run unsigned powershell scripts without configuring it (which requires admin rights)
:: I opted to do it this way, through a batch script. This allows for unpriviledged installation.  
powershell "try {(New-Object System.Net.WebClient).DownloadFile(\"%CYGWIN_URL%\", \"./cygsetup.exe\") } catch {$error[0]}"


echo *** Installing Cygwin
mkdir "var\cyglocal"
start /wait cygsetup -qDLX -s %CYG_MIRROR% -l "var\cyglocal" -R "%CYGWIN_DIR%"

echo *** Installing: %CYGWIN_PACKAGES%
start /wait cygsetup -qDLX -s %CYG_MIRROR% -l "var\cyglocal" -R "%CYGWIN_DIR%" --packages "%CYGWIN_PACKAGES%"

set PATH="%PATH%;%CYGWIN_DIR%\bin";
::setx path "%PATH%";

echo *** Running bash...
call :heredoc bash-script && goto end
############

mintty.exe -e sh -c 

## BASH_SCRIPT

git clone https://github.com/Ferk/xdg_config.git ~/.config

############
:end
echo *** Exiting...
pause
goto :EOF

:: ########################################
:: ## Here's the heredoc processing code ##
:: ########################################
:heredoc <uniqueIDX>
setlocal enabledelayedexpansion
setlocal enableextensions
set go=
for /f "delims=" %%A in ('findstr /n "^" "%~f0"') do (
    set "line=%%A" && set "line=!line:*:=!"
    if defined go (if #!line:~1!==#!go::=! (goto :EOF) else echo(!line!)
    if "!line:~0,13!"=="call :heredoc" (
        for /f "tokens=3 delims=>^ " %%i in ("!line!") do (
            if #%%i==#%1 (
                for /f "tokens=2 delims=&" %%I in ("!line!") do (
                    for /f "tokens=2" %%x in ("%%I") do set "go=%%x"
                )
            )
        )
    )
)
goto :EOF
