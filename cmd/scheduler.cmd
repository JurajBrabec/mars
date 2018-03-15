@echo off
setlocal enabledelayedexpansion
REM MARS 4.1 SCHEDULER SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
pushd %~dp0
for /f "tokens=1,2 delims=:" %%i in ("%time: =0%") do set starttime=%%i:%%j
for /f "delims=" %%i in ("%~dp0..") do set "root=%%~fi"
set "logfile=%root%\logs\scheduler.log"
:scheduler
call :echo Scheduler starting...
"%root%\bin\php\php.exe" "%root%\www\mars40\php.php">>%logfile% 2>&1
if not exist "%root%\.cmd" goto :db-dump
:post-update
call :echo Starting post-update script...
start /b /wait cmd /c "%root%\.cmd">>%logfile% 2>&1
call :echo Post-update script finished. E:%errorlevel%
del /q "%root%\.cmd" >nul 2>&1
:db-dump
for /f "tokens=1,2 delims== " %%i in ("%root%\www\mars40\config.ini") do if "%%i" equ "DB_DUMP_TIME" set dbdumptime=%%j
if "%dbdumptime%" equ "" set dbdumptime="16:00"
if "%starttime%" equ "%dbdumptime:"=%" call "%root%\cmd\export.cmd"
:finish
call :echo Scheduler stopping.
goto :end

:echo
echo %date% %time% %*
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
