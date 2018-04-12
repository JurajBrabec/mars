@echo off
REM MARS 4.1 INSTALL SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE █████████████████████████████████████████████████████████████████████████████
REM © 2018 Juraj Brabec, DXC.technology
setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :usage
:setup
if not exist "%root%\conf" mkdir "%root%\conf" >nul 2>&1
if not exist "%root%\tmp" mkdir "%root%\tmp" >nul 2>&1
set "logfile=%root%\logs\install.log"
if not exist "%root%\install.ini" copy "%root%\cmd\install\conf\install.ini" "%root%" >nul 2>&1
:begin
if /i "%1" equ "" goto :install-prompt
if /i "%1" equ "redist" goto :install-redist
if /i "%1" equ "http" goto :install-http
if /i "%1" equ "db" goto :install-db
if /i "%1" equ "task" goto :install-scheduledtask
:usage
echo MARS %build% INSTALL SCRIPT
echo USAGE: MARS install - installs MARS %build%. Make sure you've edited "%root%\install.ini" in advance.
echo.
goto :end
:install-prompt
echo [91mWARNING: You are about to install MARS %build% with following configuration (%root%\install.ini):[0m
echo.
type "%root%\install.ini" | findstr =
echo.
set /p q=To approve and continue, type 'APPROVE' (Exit):
if "%q%" equ "APPROVE" goto :install-start
echo Install process was not approved. Exiting.
goto :end
:install-start
for /f "tokens=1,2 delims== " %%i in ("%root%\install.ini") do if /i "%%i" equ "ssl" set ssl=%%j
if /i "%ssl%" equ "true" set ssl=1
if /i "%ssl%" equ "yes" set ssl=1
if "%ssl%" neq "1" set ssl=0
call :echo Installing MARS %build% Web/DB server...
set port=80
if "%ssl%" equ "1" set port=443
set "_file=%TEMP%\marsinst.tmp"
call :echo Checking ports / processes...
call :check-port %port%
call :check-port 3306
if exist %_file% goto :check-ok
call :echo Exiting.
goto :end
:check-ok
del %_file% >nul
if "%ssl%" equ "1" xcopy /q /y "%root%\cmd\install\conf\*.pem" "%root%\conf" >nul 2>&1
"%root%\bin\nodejs\node.exe" "%root%\cmd\install\install.js" %ssl%
:check-http1
call :echo Checking HTTP configuration...
if exist "%root%\conf\httpd.conf" goto :check-http2
call :echo HTTP configuration file does not exist.
goto :end
:check-http2
findstr "MARS_ROOT" "%root%\conf\httpd.conf" >nul 2>&1
if "%errorlevel%" equ "1" goto :check-php1
call :echo HTTP configuration file was not edited.
goto :end
:check-php1
call :echo Checking PHP configuration...
if exist "%root%\conf\php.ini" goto :check-php2
call :echo PHP configuration file does not exist.
goto :end
:check-php2
findstr "MARS_ROOT" "%root%\conf\php.ini" >nul 2>&1
if "%errorlevel%" equ "1" goto :check-db1
call :echo PHP configuration file was not edited.
goto :end
:check-db1
call :echo Checking DB configuration...
if exist "%root%\conf\my.ini" goto :check-db2
call :echo DB configuration file does not exist.
goto :end
:check-db2
findstr "MARS_ROOT" "%root%\conf\my.ini" >nul 2>&1
if "%errorlevel%" equ "1" goto :check-ini1
call :echo DB configuration file was not edited.
goto :end
:check-ini1
call :echo Checking MARS configuration...
if exist "%root%\conf\config.ini" goto :check-ini2
call :echo MARS configuration file does not exist.
goto :end
:check-ini2
findstr "SITE_NAME" "%root%\conf\config.ini" >nul 2>&1
if "%errorlevel%" equ "1" goto :check-xml1
call :echo MARS configuration file was not edited.
goto :end
:check-xml1
call :echo Checking XML file...
if exist "%root%\conf\mars-scheduler.xml" goto :check-xml2
call :echo XML configuration file does not exist.
goto :end
:check-xml2
findstr "MARS_ROOT" "%root%\conf\mars-scheduler.xml" >nul 2>&1
if "%errorlevel%" equ "1" goto :install-redist
call :echo XML configuration file was not edited.
goto :end
:install-redist
call :echo Installing Microsoft Visual C++ Redistributable Components...
start /wait /d "%root%\bin" vcredist_x86.exe /install /passive /promptrestart /showfinalerror
if "%errorlevel%" leq "0" goto :install-http
call :echo Error %errorlevel% installing Microsoft Visual C++ Redistributable Components.
goto :end
:install-http
call :echo Installing HTTP service...
xcopy /q /y "%root%\conf\httpd.conf" "%root%\bin\http\conf" >nul 2>&1
xcopy /q /y "%root%\conf\php.ini" "%root%\bin\php" >nul 2>&1
"%root%\bin\http\bin\httpd.exe" -k install -n MARS-HTTP
if "%errorlevel%" equ "0" goto :install-db
call :echo Error %errorlevel% installing HTTP service (MARS-HTTP).
goto :end
:install-db
call :echo Installing DB service...
xcopy /q /y "%root%\conf\my.ini" "%root%\bin\db" >nul 2>&1
"%root%\bin\db\bin\mysqld.exe" --install MARS-DB
if "%errorlevel%" equ "0" goto :database-init
call :echo Error %errorlevel% installing DB service (MARS-DB).
goto :end
:database-init
call :echo Initializing database...
call "%root%\mars.cmd" init
if "%errorlevel%" equ "0" goto :install-scheduledtask
call :echo Error %errorlevel% initializing database.
goto :end
:install-scheduledtask
call :echo Installing scheduled task...
SCHTASKS /Create /TN MARS-Scheduler /RU:SYSTEM /XML "%root%\conf\mars-scheduler.xml" /F
if "%errorlevel%" equ "0" goto :finish
call :echo Error %errorlevel% installing scheduled task (MARS-Scheduler).
goto :end
:finish
move "%root%\install.ini" "%root%\conf" >nul 2>&1
call :echo Installation finished. Please open http://localhost to continue with the configuration.
start http://localhost
goto :end

:check-port
netstat -ano -p TCP | findstr LISTENING | findstr /c:":%1 " > %_file%
if %errorlevel% EQU 1 goto :eof
for /f "tokens=1,2,3,4,5" %%i in (%_file%) do set _pid=%%m
tasklist /svc /fi "PID eq %_pid%" | findstr %_pid% > %_file%
for /f "tokens=1,2,3" %%i in (%_file%) do set _name=%%i && set _service=%%k
if %_pid% EQU 4 set _name=System&&set _service=HTTP/BranchCache
call :echo Error: A process with PID %_pid% (name "%_name%" service "%_service%") is already listening on port %1.
del %_file%
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
