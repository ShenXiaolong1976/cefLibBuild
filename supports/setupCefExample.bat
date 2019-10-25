@echo off
:: cef example :
:: https://bitbucket.org/chromiumembedded/cef-project/src/master/

:: **************************************input parameter verify ***********************************************************
::usage example:
:: call setupCefExample.bat "D:\temp\CefExample"  vs2017
set "targetDir=%~1"
if not defined targetDir set "targetDir=d:\test\cefExample"
set "VSVer=%~2"
if not defined VSVer set "VSVer=vs2017"

:: **************************************necessary implement***********************************************************
if not exist "%targetDir%" md "%targetDir%"
start "" "%targetDir%"
cd /d "%targetDir%"

echo.
echo 1. Install CMake, a cross-platform open-source build system. Version 2.8.12.1 or newer is required.
set "cmake_rurl=https://cmake.org/download/"
echo %cmake_rurl% is copied to your clipboard
echo %cmake_rurl% | clip
echo press any key to continue after you have installed cmake
pause > nul

echo.
echo 2. Install Python. Version 2.7.x is required. If Python is not installed to the default location you can set the PYTHON_EXECUTABLE environment variable before running CMake 
set "python_rurl=https://www.python.org/downloads/"
echo %python_rurl% is copied to your clipboard
echo %python_rurl% | clip
echo press any key to continue after you have installed python
pause > nul

echo.
echo 3. install Visual Studio 2013 or newer building on Windows 7 or newer is required
echo press any key to continue after you have installed Visual Studio
pause > nul


echo.
echo 4. Download the cef-project source code
set cefExample_rul=https://bitbucket.org/chromiumembedded/cef-project.git
echo from : %cefExample_rul%
if not exist "%targetDir%\cef-project" git clone %cefExample_rul%

echo.
echo 5. generate %VSVer% solution (.sln file)
cd /d "%targetDir%\cef-project"
if not exist "build" md "build"
cd /d build
:: for vs2019
:: cmake -G "Visual Studio 16" -A Win32 ..
if {"%VSVer%"}=={"vs2019"} cmake -G "Visual Studio 16" -A Win32 ..
:: for vs2017
:: cmake -G "Visual Studio 15" -A Win32 ..
if {"%VSVer%"}=={"vs2017"} cmake -G "Visual Studio 15" -A Win32 ..
:: for vs2015
:: cmake -G "Visual Studio 14" -A Win32 ..
if {"%VSVer%"}=={"vs2015"} cmake -G "Visual Studio 14" -A Win32 ..
echo VS solution is generated :
dir/s/b   cef.sln




