@echo off
REM Script to run the Navegadores scripts as administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
set "chromeScriptPath=%~dp0\navchrome.ps1"
set "edgeScriptPath=%~dp0\navedge.ps1"
set "firefoxScriptPath=%~dp0\navfirefox.ps1"
cd /d %~dp0

powershell.exe -ExecutionPolicy RemoteSigned -File "%chromeScriptPath%"
powershell.exe -ExecutionPolicy RemoteSigned -File "%edgeScriptPath%"
powershell.exe -ExecutionPolicy RemoteSigned -File "%firefoxScriptPath%"
