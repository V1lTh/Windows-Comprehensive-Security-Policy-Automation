@echo off
set "scriptPath=%~dp0\SetPolicyV2.ps1"
cd /d %~dp0
powershell.exe -ExecutionPolicy RemoteSigned -File "%scriptPath%"
sleep 1