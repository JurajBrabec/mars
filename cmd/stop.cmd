@echo off
REM MARS 4.1 STOP SERVICES SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE █████████████████████████████████████████████████████████████████████████████
REM © 2018 Juraj Brabec, DXC.technology
setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :usage
:setup
:begin
if /i "%1" equ "db" ( 
	call :service-check MARS-DB
	goto :end
)
if /i "%1" equ "http" ( 
	call :service-check MARS-HTTP
	goto :end
)
if "%1" equ "" ( 
	call :service-check MARS-DB
	call :service-check MARS-HTTP
	goto :end
)
:usage
echo MARS %build% STOP SERVICES SCRIPT
echo USAGE: stop [db^|http]
goto :end

:service-check
set service=%1
net start | find "%service%" >nul 2>&1
if "%errorlevel%" equ "0" goto :service-stop
call :echo %service% service not running.
goto :eof
:service-stop
call :echo Stopping %service% service...
net stop %service% >nul 2>&1
if "%errorlevel%" equ "0" goto :finish
call :echo %service% service NOT stopped. E:%errorlevel%
goto :eof
:finish 
call :echo %service% service stopped.
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
