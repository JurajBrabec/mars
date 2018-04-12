@echo off
REM MARS 4.1 MAIN SCRIPT 
REM DON'T MODIFY ANYTHING BELOW THIS LINE █████████████████████████████████████████████████████████████████████████████
REM © 2018 Juraj Brabec, DXC.technology
setlocal enabledelayedexpansion
pushd %~dp0
:setup
set "root=%~dp0"
if "%root:~-1%"=="\" set root=%root:~0,-1%
set command=%1
if "%logfile%" neq "" goto :begin
set "logfile=%root%\logs\mars.log"
echo [97mMARS 4.1 Monitoring And Reporting Script[0m
echo.
:begin
if "%command%" equ "" goto :usage
if "%command:~0,1%"=="/" set command=%command:~1%
if "%command:~0,1%"=="-" set command=%command:~1%
if /i "%command%" equ "scheduler" goto :mars-scheduler
if /i "%command%" equ "install" goto :mars-install
if /i "%command%" equ "uninstall" goto :mars-uninstall
if /i "%command%" equ "start" goto :service-start
if /i "%command%" equ "stop" goto :service-stop
if /i "%command%" equ "import" goto :database-import
if /i "%command%" equ "export" goto :database-export
if /i "%command%" equ "init" goto :database-init.
echo Error. Unknown command "%command%".
echo.
:usage
echo USAGE: MARS command [parameter]
echo  Command may be preceded by "/" (i.e. mars /install) or "-" (i.e. mars -install). 
echo  Parameter must be bare.
echo  All possible commands and paramters are:
echo  start [db^|http]    - Starts a service. If none specified, defaults to both services.
echo  stop [db^|http]     - Stops a service. If none specified, defaults to both services.
echo  scheduler           - Executes the scheduler (usually from Scheduled Task).
echo  export [{database}] - Imports/exports a database. If none specified, defaults to all databases.
echo  import [{database}] - Imports/exports a database. If none specified, defaults to all databases.
echo  install             - installs MARS 4.1, make sure you've edited "%root%\install.ini" in advance.
echo  init                - initializes the database to default (empty) state.
echo  uninstall           - uninstalls MARS 4.1 from the system.
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
