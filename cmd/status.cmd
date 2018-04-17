@echo off
REM MARS 4.1 STATUS SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :end
:setup
:begin
if /i "%1" equ "db" goto :status-db
if /i "%1" equ "http" goto :status-http
if /i "%1" equ "task" goto :status-task
:status-db
for /f "tokens=3 delims=- " %%i in ('%root%\bin\db\bin\mysqld.exe -V') do set db_version=%%i
set msg=running
net start | find "MARS-DB" >nul 2>&1
if "%errorlevel%" equ "1" set msg=stopped
call :echo DB service (MariaDB v%db_version%) is %msg%.
if exist "%root%\tmp\.import" call :echo Database import is in progress.
if exist "%root%\tmp\.export" call :echo Database export is in progress.
if "%1" neq "" goto :end
:status-http
for /f "tokens=4 delims=/ " %%i in ('%root%\bin\http\bin\httpd.exe -v ^|findstr version') do set http_version=%%i
for /f "tokens=2" %%i in ('%root%\bin\php\php.exe -v ^|findstr cli') do set php_version=%%i
set msg=running
net start | find "MARS-HTTP" >nul 2>&1
if "%errorlevel%" equ "1" set msg=stopped
call :echo HTTP service (Apache v%http_version% with PHP v%php_version%) is %msg%.
set msg=encrypted
findstr 443 "%root%\conf\httpd.conf" >nul 2>&1
if "%errorlevel%" equ "1" set msg=not encrypted
call :echo Web interface is %msg% with SSL/TLS.
if "%1" neq "" goto :end
:status-task
set msg=not configured
for /f "tokens=*" %%i in ('schtasks /query /tn MARS-Scheduler 2^>^&1') do set task=%%i
echo %task% | findstr Running >nul 2>&1
if "%errorlevel%" equ "0" set msg=running
echo %task% | findstr Ready >nul 2>&1
if "%errorlevel%" equ "0" set msg=enabled
echo %task% | findstr Disabled >nul 2>&1
if "%errorlevel%" equ "0" set msg=disabled
if exist "%root%\tmp\.scheduler" set msg=%msg% (in progress).
call :echo Scheduled task is %msg%.
if exist "%root%\tmp\.update" call :echo Update is in progress.
goto :end

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
