@echo off
set "scriptPath=%~dp0\AnalyzerExport.ps1"
cd /d %~dp0
powershell.exe -ExecutionPolicy Bypass -File "%scriptPath%"
sleep 1