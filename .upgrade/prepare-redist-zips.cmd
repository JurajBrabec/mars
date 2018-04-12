@echo off
setlocal enabledelayedexpansion
REM MARS 4.1 BINARY REDISTRIBUTION SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE █████████████████████████████████████████████████████████████████████████████
REM © 2018 Juraj Brabec, DXC.technology
pushd %~dp0
:setup
if "%folder%" equ "" set "folder=%~dp0"
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :setup
set "root=%folder%"
if "%root:~-1%"=="\" set root=%root:~0,-1%
:begin
for /f %%i in ('dir /b *.zip') do "%root%\bin\7z\7z.exe" d -r %%i *.pdb *.h
:end
endlocal
popd
exit /b %errorlevel%