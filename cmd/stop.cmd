@echo off
REM MARS 4.1 STOP SERVICES SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
pushd %~dp0

if "%1" equ "db" ( 
	call :check MARS-DB
	goto :end
)
if "%1" equ "http" ( 
	call :check MARS-HTTP
	goto :end
)
if "%1" equ "all" ( 
	call :check MARS-DB
	call :check MARS-HTTP
	goto :end
)
echo MARS 4.1 STOP SERVICES SCRIPT
echo USAGE: stop [http^|db^|all]
goto :end

:check
set service=%1
net start | find "%service%" >nul 2>&1
if "%errorlevel%" EQU "0" goto :stop
call :echo %service% service not running.
goto :eof

:stop
call :echo Stopping %service% service...
net stop %service% >nul 2>&1
if "%errorlevel%" NEQ "0" call :echo %service% service NOT stopped.
if "%errorlevel%" EQU "0" call :echo %service% service stopped.
goto :eof

:echo
echo %date% %time% %*
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
