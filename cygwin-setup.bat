@echo off
@setlocal ENABLEEXTENSIONS

:: BatchGotAdmin
::-------------------------------------
::  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: --> If error flag set, we do not have admin.
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
::--------------------------------------

set CYGWIN_URL="http://cygwin.com/setup-x86_64.exe"
::set CYGWIN_URL="http://cygwin.com/setup-x86.exe"
set CYG_MIRROR="http://cygwin.mirrors.pair.com/"
set CYGWIN_DIR=C:\cygwin64
set CYGWIN_PACKAGES="wget,atool,unzip,autossh,openssh,git,chere";

:: ------------------
:: CYGWIN INSTALATION
:cygwin
echo.
echo *** Creating: %CYGWIN_DIR%
mkdir "%CYGWIN_DIR%"
cd "%CYGWIN_DIR%"

where cygsetup 2> NUL
if not %ERRORLEVEL%==0 (
	echo.
	echo *** Fetching: %CYGWIN_URL%
	:: Using bitsadmin might have been more elegant, but it's a deprecated command :(
	:: Also, while it could have been possible to write the whole thing as a powershell script,
	:: it's not straightforward since you can't run unsigned powershell scripts without explicitly 
	:: configuring it (which requires administrator rights)
	powershell "try {(New-Object System.Net.WebClient).DownloadFile(\"%CYGWIN_URL%\", \"./cygsetup.exe\") } catch {$error[0]}"
)
if not %ERRORLEVEL%==0 goto :error

echo.
echo *** Installing Cygwin base system
mkdir -p "%CYGWIN_DIR%\var\cygsetup" 2> NUL
start /wait cygsetup -qADg -s "%CYG_MIRROR%" -l  "%CYGWIN_DIR%\var\cygsetup" -R "%CYGWIN_DIR%"

if not %ERRORLEVEL%==0 goto :error

echo.
echo *** Installing Cygwin packages: %CYGWIN_PACKAGES%
start /wait cygsetup -qADg -s "%CYG_MIRROR%" -l "%CYGWIN_DIR%\var\cygsetup" -R "%CYGWIN_DIR%" --packages "%CYGWIN_PACKAGES%"

if not %ERRORLEVEL%==0 goto :error

:: -----------------
:: Check that bash is available
bash --version >NUL
if %ERRORLEVEL% == 0 goto :scripts

echo.
echo *** Adding cygwin tools (%CYGWIN_DIR%\bin) to Windows PATH
set PATH=%PATH%;%CYGWIN_DIR%\bin
echo NEW PATH: %PATH%
bash --version >NUL
if not %ERRORLEVEL% == 0 goto :error
setx path %PATH%

:: -----------------
:: RUN SETUP SCRIPTS
:scripts
echo.
echo *** Running bash scripts
cd "%~dp0"
set CYGWIN="nodosfilewarning"
for %%i in (setup.d\*) do (
  echo.
  echo **** Running: %%i
  echo.
  %CYGWIN_DIR%\bin\bash %%i
  if not %ERRORLEVEL% == 0 timeout /t 10
)

:: -----------------
echo.
echo *** Success!!
:end
echo *** Exiting...
pause
goto :EOF
:error
echo *** Errors found!
goto :end