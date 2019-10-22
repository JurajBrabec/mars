@echo off
REM MARS 4.1 INSTALL FILE
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
REM
setlocal enabledelayedexpansion
pushd %~dp0
FOR /f "delims=" %%i IN ("%~dp0..") DO SET "root=%%~fi"
set "logfile=%root%\log\install.log"
if not exist "%root%\log" mkdir "%root%\log"
if not exist "%root%\tmp" mkdir "%root%\tmp"
call :echo Installing MARS 4.1 Master Server...
if "%1" neq "" goto :%1
set "_file=%TEMP%\marsinst.tmp"
call :echo Checking ports %port%/3306 and processes...
call :check-port 80
call :check-port 3306
if exist %_file% goto :check-ok
call :echo Exiting.
goto :end
:check-ok
del %_file% >nul
"%root%\bin\nodejs\node.exe" "%root%\.install\js\install.js"
if "%errorlevel%" equ "0" goto :check-ini1
call :echo MARS installation failed (E:%errorlevel%).
goto :end
:check-ini1
call :echo Checking MARS configuration...
if exist "%root%\config.ini" goto :check-ini2
call :echo MARS configuration file does not exist.
goto :end
:check-ini2
findstr "%%DB_HOST%%" "%root%\config.ini" >nul 2>&1
if "%errorlevel%" equ "1" goto :check-xml1
call :echo MARS configuration file was not edited.
goto :end
:check-xml1
call :echo Checking XML file...
if exist "%root%\.install\schtasks.xml" goto :check-xml2
call :echo XML file does not exist.
goto :end
:check-xml2
findstr "MARS_ROOT" "%root%\.install\schtasks.xml" >nul 2>&1
if "%errorlevel%" equ "1" goto :vcredist
call :echo XML file was not edited.
goto :end
:vcredist
set version=14.16.27024.01
set key=HKLM\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\x64
reg query %key% /v Version | findstr "%version%">nul
if "%errorlevel%" EQU "1" goto :vcredistinstall
call :echo Microsoft Visual C++ Redistributable Components %version% installed.
goto :task
:vcredistinstall
call :echo Installing Microsoft Visual C++ Redistributable Components %version%...
start /wait /d "%root%\bin" vc_redist.x64.exe /repair /passive /norestart
if %errorlevel% equ 1638 ver>nul
if %errorlevel% equ 3010 ver>nul
if %errorlevel% leq 0 goto :task
call :echo Error %errorlevel% installing Microsoft Visual C++ Redistributable Components %version%.
goto :end
:task
call :echo Installing scheduled task...
SCHTASKS /Create /TN MARS /RU:SYSTEM /XML "%root%\.install\schtasks.xml" /F
if "%errorlevel%" equ "0" goto :finish
call :echo Error %errorlevel% installing scheduled task.
goto :end
:finish
call :echo Finished. You can remove "%root%\.install" folder.
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
echo %date% %time% %*
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
