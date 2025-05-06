@echo off
set "scriptPath=%~dp0\callfiles.ps1"
cd /d %~dp0
powershell.exe -ExecutionPolicy RemoteSigned -File "%scriptPath%"
sleep 1