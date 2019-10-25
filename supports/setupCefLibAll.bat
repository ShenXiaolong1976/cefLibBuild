@echo off
:: setup environment:
:: https://bitbucket.org/chromiumembedded/cef/wiki/MasterBuildQuickStart#markdown-header-windows-setup
:: libcef source download:
:: http://opensource.spotify.com/cefbuilds/index.html
:: cef wiki :
:: https://bitbucket.org/chromiumembedded/cef/wiki/browse/

:: **************************************input parameter verify ***********************************************************
::usage example:
:: call setupBuildEnv.bat "D:\temp\ceflib"  vs2017
set "targetDir=%~1"
if not defined targetDir set "targetDir=d:\test\cefAll"
set "VSVer=%~2"
if not defined VSVer set "VSVer=vs2017"

:: **************************************optional implement***********************************************************

echo enable possible fast build option
set GN_DEFINES=use_jumbo_build=true
:: set GN_ARGUMENTS=--ide=%VSVer% --sln=cef --filters=//cef/*
set GN_ARGUMENTS=--ide=vs --sln=cef --filters=//cef/*

echo config msvc setting
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set GYP_GENERATORS=ninja,msvs-ninja
set GYP_MSVS_VERSION=%VSVer:~2%

echo enable source-level debugging
set symbol_level = 2

:: **************************************necessary implement***********************************************************
set "batDir=%~dp0.."
if not exist "%targetDir%" md "%targetDir%"
cd /d "%targetDir%"
start "" "%targetDir%"

echo.
echo used visual studio version :  %VSVer%

echo.
echo 1. create directory "automate" and "chromium_git"
if not exist "%targetDir%\automate" md "%targetDir%\automate"
if not exist "%targetDir%\chromium_git" md "%targetDir%\chromium_git"

echo.
echo 2. download depot_tools.zip and extract to %targetDir%\depot_tools 
::bitsadmin.exe /transfer "depot_tools.zip"  /download  /priority normal "https://storage.googleapis.com/chrome-infra/depot_tools.zip" "%targetDir%"
if not exist "%targetDir%\depot_tools.zip" curl "https://storage.googleapis.com/chrome-infra/depot_tools.zip" -o "%targetDir%\depot_tools.zip"
if not exist "%targetDir%\depot_tools" 7z.exe x "%targetDir%\depot_tools.zip" -o"%targetDir%\depot_tools"

echo.
echo 3. update depot_tools
cd /d "%targetDir%\depot_tools"
call update_depot_tools.bat


echo.
echo 4. add %targetDir%\depot_tools in path environement variable
where update_depot_tools.bat || set "path=%targetDir%\depot_tools;%path%"

echo.
echo 5. Download the automate-git.py script to "%targetDir%\automate\automate-git.py".
::bitsadmin.exe /transfer "automate-git.py"  /download  /priority normal "https://bitbucket.org/chromiumembedded/cef/raw/master/tools/automate/automate-git.py" "%targetDir%\automate"
if not exist "%targetDir%\automate\automate-git.py" curl  "https://bitbucket.org/chromiumembedded/cef/raw/master/tools/automate/automate-git.py" -o "%targetDir%\automate\automate-git.py"

echo.
echo 6. Create the "%targetDir%\chromium_git\update.bat"
if not exist "%targetDir%\chromium_git\update.bat" copy "%batDir%\copiedTools\update.bat" "%targetDir%\chromium_git\update.bat"
if not exist "%targetDir%\depot_tools\git.bat" copy "%batDir%\copiedTools\git.bat" "%targetDir%\depot_tools\update.bat"

echo.
echo 6.1. Run the "update.bat" script and wait for CEF and Chromium source code to download
echo CEF source code will be downloaded to "%targetDir%\chromium_git\cef" 
echo Chromium source code will be downloaded to "%targetDir%\chromium_git\chromium\src". 
echo After download completion the CEF source code will be copied to "%targetDir%\chromium_git\chromium\src\cef".
cd /d "%targetDir%\chromium_git"
call  update.bat

echo.
echo 7. Create the "%targetDir%\chromium_git\chromium\src\cef\create.bat"
if not exist "%targetDir%\chromium_git\chromium\src\cef\create.bat" copy "%batDir%\copiedTools\create.bat" "%targetDir%\chromium_git\chromium\src\cef\create.bat"

echo.
echo 7.1 create %targetDir%\chromium_git\chromium\src\out\Debug_GN_x86\cef.sln
cd /d "%targetDir%\chromium_git\chromium\src\cef"
call create.bat

echo.
echo 8. Create a Debug build of CEF/Chromium using Ninja
cd  /d "%targetDir%\chromium_git\chromium\src"
ninja.exe -C out\Debug_GN_x86 cef

echo.
echo Run the resulting cefclient sample application
cd  /d "%targetDir%\chromium_git\chromium\src"
out\Debug_GN_x86\cefclient.exe

