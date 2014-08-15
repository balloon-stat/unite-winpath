@echo off
cd /d %~dp0
if %1 equ add    powershell -ExecutionPolicy RemoteSigned -File .\add_path.ps1    %2
if %1 equ delete powershell -ExecutionPolicy RemoteSigned -File .\delete_path.ps1 %2

