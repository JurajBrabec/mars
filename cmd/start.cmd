@echo off
REM MARS 4.1 START SERVICES SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
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
echo MARS 4.1 START SERVICES SCRIPT
echo USAGE: start [db^|http]
goto :end

:service-check
set service=%1
net start | find "%service%" >nul 2>&1
if "%errorlevel%" EQU "1" goto :service-start
call :echo %service% service already running.
goto :eof
:service-start
if "%service%" equ "MARS-DB" (
	xcopy /y "%root%\conf\my.ini" "%root%\bin\db\" >nul 2>&1
	del /q "%root%\data\*.log" >nul 2>&1
)
if "%service%" equ "MARS-HTTP" (
	xcopy /y "%root%\conf\httpd.conf" "%root%\bin\http\conf\" >nul 2>&1
	xcopy /y "%root%\conf\php.ini" "%root%\bin\php\" >nul 2>&1
	del /q /f "%root%\bin\http\logs\*.*" >nul 2>&1
)
call :echo Starting %service% service...
net start %service% >nul 2>&1
if "%errorlevel%" equ "0" goto :finish
call :echo %service% service NOT started. E:%errorlevel%
goto :eof
:finish
call :echo %service% service started.
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
