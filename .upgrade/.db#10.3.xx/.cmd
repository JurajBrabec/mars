@echo off
REM MARS 4.1 DB UPDATE PART#1 SCRIPT
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
for /f %%i in ('dir /b files\mariadb-*.zip') do set filename=%%i
for /f "tokens=2 delims=-" %%i in ("%filename%") do set build=%%i
set "logfile=%root%\logs\update_db_%build%.log"
if exist %logfile% del /q %logfile%
set webinterface=0
if "%1" equ "WEBINTERFACE" set webinterface=1
if "%scheduler%" equ "1" goto :begin
set scheduler=0
tasklist | findstr php.exe >nul 2>&1
if "%errorlevel%" equ "0" set scheduler=1
:begin
call :echo MARS DB (MariaDB) update %build% part#1 starting...
if "%scheduler%" equ "1" call :echo (started from scheduler)
if "%webinterface%" equ "1" call :echo (started from web interface)
call :echo Copying file(s)...
for /f %%i in ("%~dp0.") do set postupdate=%%~nxi.cmd
xcopy /e /i /y files "%root%\tmp" >nul 2>&1
if "%errorlevel%" neq "0" goto :error
:finish
if exist "%root%\tmp\%postupdate%" ( 
	del /q /f "%root%\tmp\%postupdate%" > nul 2>&1
)
ren "%root%\tmp\.cmd" %postupdate% >nul 2>&1
if "%scheduler%%webinterface%" equ "00" goto :post-update
findstr %postupdate% "%root%\tmp\.updates" >nul 2>&1
if "%errorlevel%" equ "1" echo %postupdate%>>"%root%\tmp\.updates" 
goto :success
:post-update
call :echo Starting post-update script %postupdate%...
start /b /wait cmd /c "%root%\tmp\%postupdate%" 2>&1
call :echo Post-update script %postupdate% finished. E:%errorlevel%
if "%errorlevel%" neq "0" goto :error
del /q "%root%\tmp\%postupdate%" >nul 2>&1

:success
call :echo MARS DB (MariaDB) update %build% part#1 successful.
goto :end

:error
call :echo Error %errorlevel%. MARS DB (MariaDB) update %build% failed.
goto :end

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
exit /b %errorlevel%
