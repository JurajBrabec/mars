@echo off
REM MARS 4.1 UNINSTALL SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :end
:setup
set "logfile=%root%\logs\uninstall.log"
:begin
if /i "%1" equ "" goto :uninstall-prompt
if /i "%1" equ "http" goto :uninstall-http
if /i "%1" equ "db" goto :uninstall-db
if /i "%1" equ "task" goto :uninstall-scheduledtask
:usage
echo MARS %build% UNINSTALL SCRIPT
echo USAGE: MARS uninstall - uninstalls MARS from the system.
echo.
goto :end
:uninstall-prompt
echo WARNING: You are about to uninstall MARS %build% from the system.
set /p q=To approve and continue, type 'APPROVE' (Exit):
if "%q%" equ "APPROVE" goto :uninstall-start
echo Uninstall process was not approved. Exiting.
goto :end
:uninstall-start
call :echo Uninstalling MARS %build% Web/DB server...
:uninstall-stop-services
call "%root%\mars.cmd" stop
if "%errorlevel%" equ "0" goto :uninstall-http
call :echo Error %errorlevel% stopping services.
goto :end
:uninstall-http
call :echo Uninstalling HTTP service...
"%root%\bin\http\bin\httpd.exe" -k uninstall -n MARS-HTTP
if "%errorlevel%" equ "0" goto :uninstall-db
call :echo Error %errorlevel% uninstalling HTTP service (MARS-HTTP).
goto :end
:uninstall-db
call :echo Uninstalling DB service...
"%root%\bin\db\bin\mysqld.exe" --remove MARS-DB
if "%errorlevel%" equ "0" goto :uninstall-scheduledtask
call :echo Error %errorlevel% uninstalling DB service (MARS-DB).
goto :end
:uninstall-scheduledtask
call :echo Uninstalling scheduled task...
schtasks /query /tn MARS-Scheduler > nul 2>&1
if "%errorlevel%" equ "1" (
	ver>nul
	goto :finish
)
schtasks /delete /tn MARS-Scheduler /f 2>&1
if "%errorlevel%" equ "0" goto :finish
call :echo Error %errorlevel% uninstalling scheduled task (MARS-Scheduler).
goto :end
:finish
call :echo Finished. You may remove "%root%" folder now.
goto :end

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
exit /b %errorlevel%
