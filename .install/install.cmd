@echo off
REM MARS 4.1 INSTALL FILE
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
REM
setlocal enabledelayedexpansion
pushd %~dp0
FOR /f "delims=" %%i IN ("%~dp0..") DO SET "root=%%~fi"
set "logfile=%root%\logs\install.log"
call :echo Installing MARS 4.1 Web/DB server...
set port=80
if "%1" equ "SSL" set port=443
set "_file=%TEMP%\marsinst.tmp"
call :echo Checking ports / processes...
call :checkport %port%
call :checkport 3306
if exist %_file% goto :check-ok
call :echo Exiting.
goto :end
:check-ok
del %_file% >nul
if "%1" equ "SSL" xcopy /q /y "%root%\.install\conf\*.pem" "%root%\conf" >nul 2>&1
"%root%\bin\nodejs\node.exe" "%root%\.install\js\install.js" %1
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
if exist "%root%\www\mars40\config.ini" goto :check-ini2
call :echo MARS configuration file does not exist.
goto :end
:check-ini2
findstr "SITE_NAME" "%root%\www\mars40\config.ini" >nul 2>&1
if "%errorlevel%" equ "1" goto :check-xml1
call :echo MARS configuration file was not edited.
goto :end
:check-xml1
call :echo Checking XML file...
if exist "%root%\.install\schtasks.xml" goto :check-xml2
call :echo XML configuration file does not exist.
goto :end
:check-xml2
findstr "MARS_ROOT" "%root%\.install\schtasks.xml" >nul 2>&1
if "%errorlevel%" equ "1" goto :redist
call :echo XML configuration file was not edited.
goto :end
:redist
call :echo Installing Microsoft Visual C++ Redistributable Components...
start /wait %root%\bin\vcredist_x86.exe /install /passive /promptrestart /showfinalerror
if "%errorlevel%" equ "0" goto :http
call :echo Error %errorlevel% installing Microsoft Visual C++ Redistributable Components.
goto :end
:http
call :echo Installing HTTP service...
xcopy /q /y "%root%\conf\httpd.conf" "%root%\bin\http\conf" >nul 2>&1
xcopy /q /y "%root%\conf\php.ini" "%root%\bin\php" >nul 2>&1
"%root%\bin\http\bin\httpd.exe" -k install -n MARS-HTTP
if "%errorlevel%" equ "0" goto :db
call :echo Error %errorlevel% installing HTTP service.
goto :end
:db
call :echo Installing DB service...
xcopy /q /y "%root%\conf\my.ini" "%root%\bin\db" >nul 2>&1
"%root%\bin\db\bin\mysqld.exe" --install MARS-DB
if "%errorlevel%" equ "0" goto :init
call :echo Error %errorlevel% installing DB service.
goto :end
:init
call :echo Initializing database...
call "%root%\cmd\init.cmd"
if "%errorlevel%" equ "0" goto :task
call :echo Error %errorlevel% initializing database.
goto :end
:task
call :echo Installing scheduled task...
SCHTASKS /Create /TN MARS-Scheduler /RU:SYSTEM /XML "%root%\.install\schtasks.xml" /F
if "%errorlevel%" equ "0" goto :finish
call :echo Error %errorlevel% installing scheduled task.
goto :end
:finish
call :echo Finished. You may remove "%root%\.install" folder now.
start http://localhost
goto :end

:checkport
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
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
