@echo off
REM MARS 4.1 MAIN SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
pushd %~dp0
:setup
set "root=%~dp0"
if "%root:~-1%"=="\" set root=%root:~0,-1%
if "%logfile%" neq "" goto :begin
set "logfile=%root%\logs\mars.log"
echo [97mMARS 4.1 Monitoring And Reporting Script[0m
echo.
:begin
if /i "%1" equ "scheduler" goto :mars-scheduler
if /i "%1" equ "install" goto :mars-install
if /i "%1" equ "uninstall" goto :mars-uninstall
if /i "%1" equ "start" goto :service-start
if /i "%1" equ "stop" goto :service-stop
if /i "%1" equ "import" goto :database-import
if /i "%1" equ "export" goto :database-export
if /i "%1" equ "init" goto :database-init
:usage
echo USAGE: MARS command [parameter]
echo Commands and paramters:
echo (start^|stop) [db^|http] - Starts/stops a service. If none specified, defaults to all services.
echo (import^|export) [{database}] - Imports/exports a database. If none specified, defaults to all databases.
echo scheduler - Executes the scheduler (usually from Scheduled Task).
echo init - initializes the database to default (empty) state.
echo install - installs MARS 4.1, make sure you've edited "%root%\install.ini" in advance.
echo uninstall - uninstalls MARS 4.1 from the system.
goto :end
:service-start
call :echo Starting services(s) %2
call "%root%\cmd\start.cmd" %2
goto :end
:service-stop
call :echo Stopping services(s) %2
call "%root%\cmd\stop.cmd" %2
goto :end
:database-import
call :echo Importing database(s) %2
call "%root%\cmd\import.cmd" %2
goto :end
:database-export
call :echo Exporting database(s) %2
call "%root%\cmd\export.cmd" %2
goto :end
:database-init
call :echo Initializing database %2
call "%root%\cmd\init.cmd" %2
goto :end
:mars-scheduler
call :echo Executing scheduler %2
call "%root%\cmd\scheduler.cmd" %2
goto :end
:mars-install
call :echo Installing %2
call "%root%\cmd\install.cmd" %2
goto :end
:mars-uninstall
call :echo Uninstalling %2
call "%root%\cmd\uninstall.cmd" %2
goto :end

:echo
rem echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
