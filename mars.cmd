@echo off
REM MARS 4.1 MAIN SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
pushd %~dp0
set "root=%~dp0"

if "%1" equ "start" goto :start
if "%1" equ "stop" goto :stop
if "%1" equ "scheduler" goto :scheduler
if "%1" equ "import" goto :import
if "%1" equ "export" goto :export
if "%1" equ "init" goto :init

echo MARS 4.1 Monitoring And Reporting Script
echo USAGE: MARS [start^|stop^|scheduler^|import^|export^|init]
echo.
echo  MARS start [http^|db^|all] - starts a(ll) service(s).
echo  MARS stop [http^|db^|all] - stops a(ll) service(s).
echo  MARS scheduler - executes the scheduler (usually from Scheduled Task).
echo  MARS export - creates a database dump (backup).
echo  MARS import - import a previously created database dump.
echo  MARS init - initializes the database to default (empty) state.
goto :end
:start
call "%root%\cmd\start.cmd" %2 %3
goto :end
:stop
call "%root%\cmd\stop.cmd" %2 %3
goto :end
:scheduler
call "%root%\cmd\scheduler.cmd"
goto :end
:import
call "%root%\cmd\import.cmd"
goto :end
:export
call "%root%\cmd\export.cmd"
goto :end
:init
call "%root%\cmd\init.cmd"
goto :end

:end
endlocal
popd
exit /b %errorlevel%
