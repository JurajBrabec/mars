@echo off
REM MARS 4.1 SCHEDULER SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :end
:setup
set "logfile=%root%\logs\scheduler.log"
for /f "tokens=1,2 delims=:" %%i in ("%time: =0%") do set starttime=%%i:%%j
set command=%1
:begin
if "%command%" equ "" goto :start
if "%command:~0,1%"=="/" set command=%command:~1%
if "%command:~0,1%"=="-" set command=%command:~1%
if /i "%command%" equ "enable" goto :enable
if /i "%command%" equ "disable" goto :disable
if /i "%command%" equ "update" goto :update
goto :start
:enable
schtasks /change /tn MARS-Scheduler /enable >nul 2>&1
call "%root%\cmd\status.cmd" task
goto :end
:disable
schtasks /change /tn MARS-Scheduler /disable >nul 2>&1
call "%root%\cmd\status.cmd" task
goto :end
:start
if "%command%" neq "" set starttime=%command%
call :echo Scheduler starting for %starttime%...
echo.>"%root%\tmp\.scheduler"
if exist "%root%\www\nbu\php.php" "%root%\bin\php\php.exe" "%root%\www\nbu\php.php">>"%logfile%" 2>&1
if exist "%root%\www\dp\index.php" "%root%\bin\php\php.exe" "%root%\www\dp\index.php" s=scheduler>>"%logfile%" 2>&1
del /q "%root%\tmp\.scheduler" >nul 2>&1
if not exist "%root%\tmp\.updates" goto :database-dump
:update
if exist "%root%\tmp\.updates" goto :updates
call :echo No pending updates available.
goto :end
:updates
echo.>"%root%\tmp\.update"
for /f %%i in (%root%\tmp\.updates) do call :post-update %%i
del /q "%root%\tmp\.updates" >nul 2>&1
del /q "%root%\tmp\.update" >nul 2>&1
if /i "%command%" equ "update" goto :end
:database-dump
set dbdumptime="16:00"
for /f "tokens=1,2 delims== " %%i in ("%root%\conf\config.ini") do if /i "%%i" equ "db_dump_time" set dbdumptime=%%j
if "%starttime%" equ "%dbdumptime:"=%" call "%root%\mars.cmd" export
:finish
call :echo Scheduler finished.
goto :end

:post-update
if not exist "%root%\tmp\%1" (
	call :echo Post-update script %1 does not exist.
	goto :eof
)
call :echo Starting post-update script %1...
start /b /wait cmd /c "%root%\tmp\%1">>"%logfile%" 2>&1
call :echo Post-update script finished. E:%errorlevel%
del /q "%root%\tmp\%1" >nul 2>&1
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
exit /b %errorlevel%
