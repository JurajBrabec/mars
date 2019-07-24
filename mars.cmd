@echo off
REM MARS 4.1 MAIN SCRIPT 
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
:setup
set "root=%~dp0"
if "%root:~-1%"=="\" set root=%root:~0,-1%
if not exist build echo 4.1>build
for /f %%i in (build) do set build=%%i
set command=%1
if "%logfile%" neq "" goto :begin
if not exist "%root%\logs" mkdir "%root%\logs" >nul 2>&1
set "logfile=%root%\logs\mars.log"
echo MARS %build% Monitoring And Reporting Script
echo ==========================================================================
echo.
if "%command%" equ "" goto :usage
:begin
if "%command:~0,1%"=="-" set command=%command:~1%
if "%command:~0,1%"=="-" goto :begin
if "%command:~0,1%"=="/" set command=%command:~1%
if /i "%command%" equ "?" goto :usage
if /i "%command%" equ "help" goto :usage
if /i "%command%" equ "disable" goto :scheduler-disable
if /i "%command%" equ "enable" goto :scheduler-enable
if /i "%command%" equ "status" goto :mars-status
if /i "%command%" equ "scheduler" goto :mars-scheduler
if /i "%command%" equ "install" goto :mars-install
if /i "%command%" equ "uninstall" goto :mars-uninstall
if /i "%command%" equ "restart" goto :service-restart
if /i "%command%" equ "start" goto :service-start
if /i "%command%" equ "stop" goto :service-stop
if /i "%command%" equ "import" goto :database-import
if /i "%command%" equ "export" goto :database-export
if /i "%command%" equ "init" goto :database-init
if /i "%command%" equ "heidisql" goto :database-heidisql
if /i "%command%" equ "webinterface" goto :mars-webinterface
echo Error. Unknown command "%command%".
echo.
:usage
echo USAGE: MARS command [parameter]
echo  Command may be preceded by "/" (i.e. mars /install) or "-" (i.e. mars -install). 
echo  Parameter must be bare.
echo  Comonly used commands ^& parameters:
echo  -status              - Displays various status information.
echo  -start [db^|http]     - Starts a service. Defaults to both services.
echo  -stop [db^|http]      - Stops a service. Defaults to both services.
echo  -restart [db^|http]   - Restarts a service. Defaults to both services.
echo  -disable             - Disables the scheduler.
echo  -enable              - Enables the scheduler (if it was disabled).
echo  Rarely used commands ^& parameters:
echo  -scheduler [HH:MM]   - Executes the scheduler. You may specify a time to emualte.
echo  -export [{database}] - Imports/exports a database. Defaults to all databases.
echo  -import [{database}] - Imports/exports a database. Defaults to all databases.
echo  -init                - initializes the database to default (empty) state.
echo  -webinterface        - Starts the web interface.
echo  -heidisql            - Starts the HeidiSQL tool.
echo  Commands used once (or never):
echo  -install             - installs MARS 4.1, Edit "%root%\install.ini" first.
echo  -uninstall           - uninstalls MARS 4.1 from the system.
goto :end
:mars-status
call "%root%\cmd\status.cmd" %2
goto :end
:service-restart
call :echo Restarting services(s) %2...
call "%root%\cmd\stop.cmd" %2
call "%root%\cmd\start.cmd" %2
goto :end
:service-start
call :echo Starting services(s) %2...
call "%root%\cmd\start.cmd" %2
goto :end
:service-stop
call :echo Stopping services(s) %2...
call "%root%\cmd\stop.cmd" %2
goto :end
:database-import
call :echo Importing database(s) %2 %3...
call "%root%\cmd\import.cmd" %2 %3
goto :end
:database-export
call :echo Exporting database(s) %2 %3...
call "%root%\cmd\export.cmd" %2 %3
goto :end
:database-init
call :echo Initializing database %2...
call "%root%\cmd\init.cmd" %2
goto :end
:mars-scheduler
call :echo Executing scheduler %2...
call "%root%\cmd\scheduler.cmd" %2
goto :end
:scheduler-disable
call :echo Disabling scheduler...
call "%root%\cmd\scheduler.cmd" %1
goto :end
:scheduler-enable
call :echo Enabling scheduler...
call "%root%\cmd\scheduler.cmd" %1
goto :end
:mars-install
call :echo Installing %2...
call "%root%\cmd\install.cmd" %2
goto :end
:mars-uninstall
call :echo Uninstalling %2...
call "%root%\cmd\uninstall.cmd" %2
goto :end
:database-heidisql
call :echo Starting HeidiSQL...
start %root%\bin\heidisql\heidisql.exe
goto :end
:mars-webinterface
call :echo Opening the web interface...
start http://localhost
goto :end

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
exit /b %errorlevel%
