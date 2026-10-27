@echo off
rem Toggle komorebi, whkd and komorebi-bar: stop them if komorebi is running, otherwise start them.
rem Synced to Documents by komorebi-win-sync from ~/dotfiles/windows/komorebi; edit it there.
rem Reads the config dirs from the registry so it works even if Explorer's environment is stale.
for /f "tokens=2,*" %%a in ('reg query HKCU\Environment /v KOMOREBI_CONFIG_HOME 2^>nul ^| findstr KOMOREBI_CONFIG_HOME') do set "KOMOREBI_CONFIG_HOME=%%b"
for /f "tokens=2,*" %%a in ('reg query HKCU\Environment /v WHKD_CONFIG_HOME 2^>nul ^| findstr WHKD_CONFIG_HOME') do set "WHKD_CONFIG_HOME=%%b"
set "PATH=%ProgramFiles%\komorebi\bin;%ProgramFiles%\whkd\bin;%PATH%"
tasklist /fi "imagename eq komorebi.exe" | find /i "komorebi.exe" >nul
if %errorlevel%==0 (komorebic stop --whkd --bar) else (komorebic start --whkd --bar)
