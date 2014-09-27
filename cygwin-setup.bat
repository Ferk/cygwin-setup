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
set CYGWIN_DIR=C:\cygwin64
set CYGWIN_PACKAGES="cygutils,cygutils-extra,wget,atool,unzip,openssh,git,chere,shutdown,nosleep,ncdu";

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
echo *** Installing Cygwin
mkdir -p "%CYGWIN_DIR%\var\cygsetup" 2> NUL
start /wait cygsetup -MAWDLg -l  "%CYGWIN_DIR%\var\cygsetup" -R "%CYGWIN_DIR%" ^
	-C "Base" --packages "%CYGWIN_PACKAGES%"
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
cd "%~dp0"
set CYGWIN="nodosfilewarning"
if exist setup.d goto :scriptsRun
echo.
echo Warning: no setup scripts directory found in working directory.
echo          Will use /opt/cygwin-setup instead.
cd "%CYGWIN_DIR%\"
if not exist opt mkdir opt
cd opt
if exist cygwin-setup goto :scriptsUseGit

echo.
echo *** Fetching setup scripts
:: Download and unpack scripts if not existing
git clone 'https://github.com/Ferk/cygwin-setup' cygwin-setup
if not %ERRORLEVEL%==0 goto :error

:scriptsUseGit
cd cygwin-setup
git pull

:scriptsRun
echo.
echo *** Running setup scripts
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
