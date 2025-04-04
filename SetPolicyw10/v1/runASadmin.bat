@echo off
set "scriptPath=%~dp0\clara100.ps1"
cd /d %~dp0
powershell.exe -ExecutionPolicy Bypass -File "%scriptPath%"
sleep 1