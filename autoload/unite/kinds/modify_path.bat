@echo off
cd /d %~dp0
powershell Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
if %1 equ add    powershell -File .\add_path.ps1    %2
if %1 equ delete powershell -File .\delete_path.ps1 %2
powershell Set-ExecutionPolicy -Scope CurrentUser Restricted

