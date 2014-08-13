@echo off
cd /d %~dp0
powershell Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
if %1 equ add    powershell -File .\add_path.ps1    %2
if %1 equ remove powershell -File .\remove_path.ps1 %2
powershell Set-ExecutionPolicy -Scope CurrentUser Restricted

