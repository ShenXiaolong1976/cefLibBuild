
:: copy me to ".\chromium_git\chromium\src\cef\create.bat"
if not defined VSVer set VSVer=vs2017

set GN_DEFINES=use_jumbo_build=true is_component_build=true
set GN_ARGUMENTS=--ide=%VSVer% --sln=cef --filters=//cef/*
call cef_create_projects.bat