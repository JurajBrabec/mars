@echo off
REM MARS 4.1 START SERVICES SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
pushd %~dp0
set "folder=%~dp0"
:find-root
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :find-root
set "root=%folder%"
if "%2" neq "" set "logfile=%2"

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
echo MARS 4.1 START SERVICES SCRIPT
echo USAGE: start [http^|db^|all]
goto :end
:check
set service=%1
net start | find "%service%" >nul 2>&1
if "%errorlevel%" EQU "1" goto :prepare
call :echo %service% service already running.
goto :eof

:prepare
if "%service%" equ "MARS-DB" (
	xcopy /y "%root%\conf\my.ini" "%root%\bin\db\" >nul 2>&1
	del /q "%root%\data\*.log" >nul 2>&1
)
if "%service%" equ "MARS-HTTP" (
	xcopy /y "%root%\conf\httpd.conf" "%root%\bin\http\conf\" >nul 2>&1
	xcopy /y "%root%\conf\php.ini" "%root%\bin\php\" >nul 2>&1
	del /q /f "%root%\bin\http\logs\*.*" >nul 2>&1
)
:start
call :echo Starting %service% service...
net start %service% >nul 2>&1
if "%errorlevel%" NEQ "0" call :echo %service% service NOT started (Error %errorlevel%).
if "%errorlevel%" EQU "0" call :echo %service% service started.
goto :eof

:echo
echo %time% %*
if "%logfile%" equ "" goto :eof
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
