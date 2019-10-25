@echo off
setlocal
if not defined EDITOR set EDITOR=notepad
git.exe %*
