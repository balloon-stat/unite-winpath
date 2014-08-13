cd /d %~dp0
powershell Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
powershell -File .\add_path.ps1 %1
powershell Set-ExecutionPolicy -Scope CurrentUser Restricted
