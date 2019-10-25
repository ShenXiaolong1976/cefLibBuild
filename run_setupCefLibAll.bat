@echo off
where 7z.exe 2>nul || @set "path=D:\UserApps\7-Zip;%path%"
where 7z.exe 2>nul || ( echo can't find 7z.exe to extract file.  &  pause & goto :eof )

where git.exe 2>nul || @set "path=C:\Program Files\Git\cmd;%path%"
where git.exe 2>nul || ( echo can't find git.exe to clone repo.  &  pause & goto :eof )

call "%~dp0supports\setupCefLibAll.bat" "d:\test\cefAll" vs2017

echo.
echo Done.
echo pause