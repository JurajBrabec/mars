@echo off
REM MARS 4.1 BINARY REDISTRIBUTION SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
:setup
if "%folder%" equ "" set "folder=%~dp0"
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :setup
set "root=%folder%"
if "%root:~-1%"=="\" set root=%root:~0,-1%
:begin
for /f %%i in ('dir /b *.zip') do "%root%\bin\7z\7z.exe" d -r %%i *.pdb *.h *.lib *.sql *.pl php.ini-* data dev extras include manual lib sasl2
:end
popd
exit /b %errorlevel%
