:: the setup of an automated build system for CEF.
:: https://bitbucket.org/chromiumembedded/cef/wiki/AutomatedBuildSetup#markdown-header-windows-configuration

:: **************************************input parameter verify ***********************************************************
::usage example:
:: call buildCefAuto.bat "D:\temp\cefAutoBuild"  3538
set "targetDir=%~1"
if not defined targetDir set "targetDir=d:\test\cefAll"
set "VSVer=%~2"
if not defined VSVer set "VSVer=vs2017"
set "branch=%~3"
if not defined branch set "branch=3538"


:: **************************************necessary implement***********************************************************
if not exist "%targetDir%" md "%targetDir%"
cd /d "%targetDir%"
start "" "%targetDir%"

echo.
echo 1. Download the automate-git.py script to "%targetDir%\automate\automate-git.py".
if not exist "%targetDir%\automate" md "%targetDir%\automate"
::bitsadmin.exe /transfer "automate-git.py"  /download  /priority normal "https://bitbucket.org/chromiumembedded/cef/raw/master/tools/automate/automate-git.py" "%targetDir%\automate"
if not exist "%targetDir%\automate\automate-git.py" curl  "https://bitbucket.org/chromiumembedded/cef/raw/master/tools/automate/automate-git.py" -o "%targetDir%\automate\automate-git.py"


echo.
echo run automate-git.py
set GN_DEFINES=use_jumbo_build=true
set GN_ARGUMENTS=--ide=%VSVer% --sln=cef --filters=//cef/*
python "%targetDir%\automate\automate-git.py" --download-dir=%targetDir%\download --branch=%branch% --minimal-distrib --client-distrib --force-clean
