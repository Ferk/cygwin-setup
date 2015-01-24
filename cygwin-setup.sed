# This file is intended to be used with Windows iexpress.exe
# to generate an executable installation file with the setup launching script.
#
# To Package the exe out of the batch file, use this command:
#        iexpress /N /Q cygwin-setup.sed
#
[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=0
HideExtractAnimation=1
UseLongFileName=1
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=%InstallPrompt%
DisplayLicense=%DisplayLicense%
FinishMessage=%FinishMessage%
TargetName=%TargetName%
FriendlyName=%FriendlyName%
AppLaunched=%AppLaunched%
PostInstallCmd=%PostInstallCmd%
AdminQuietInstCmd=%AdminQuietInstCmd%
UserQuietInstCmd=%UserQuietInstCmd%
SourceFiles=SourceFiles
[Strings]
InstallPrompt=
DisplayLicense=
FinishMessage=
TargetName=cygwin-setup.exe
FriendlyName=Cygwin Setup
AppLaunched=cmd /c cygwin-setup.bat
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="cygwin-setup.bat"
[SourceFiles]
SourceFiles0=.\
[SourceFiles0]
%FILE0%=
