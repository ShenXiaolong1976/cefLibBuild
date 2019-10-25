
if not defined targetDir set "targetDir=%~dp0.."
set "path=%targetDir%\depot_tools;%path%"

if not defined VSVer set VSVer=vs2017

set GN_DEFINES=use_jumbo_build=true is_component_build=true
set GN_ARGUMENTS=--ide=%VSVer% --sln=cef --filters=//cef/*
python %targetDir%\automate\automate-git.py --download-dir=%targetDir%\chromium_git --depot-tools-dir=%targetDir%\depot_tools --no-distrib --no-build