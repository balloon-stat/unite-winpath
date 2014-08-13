@echo off
cd /d %~dp0
powershell Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
powershell -File .\get_path.ps1
powershell Set-ExecutionPolicy -Scope CurrentUser Restricted


