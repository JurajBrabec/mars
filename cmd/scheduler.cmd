@echo off
setlocal enabledelayedexpansion
REM MARS 4.1 SCHEDULER SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
pushd %~dp0
set "folder=%~dp0"
:find-root
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :find-root
set "root=%folder%"
for /f "tokens=1,2 delims=:" %%i in ("%time: =0%") do set starttime=%%i:%%j
set "logfile=%root%\logs\scheduler.log"
:scheduler
call :echo Scheduler starting...
"%root%\bin\php\php.exe" "%root%\www\mars40\php.php">>%logfile% 2>&1
if not exist "%root%\.updates" goto :db-dump
:updates
for /f %%i in (%root%\.updates) do call :post-update %%i
del /q "%root%\.updates" >nul 2>&1
:db-dump
for /f "tokens=1,2 delims== " %%i in ("%root%\www\mars40\config.ini") do if "%%i" equ "DB_DUMP_TIME" set dbdumptime=%%j
if "%dbdumptime%" equ "" set dbdumptime="16:00"
if "%starttime%" equ "%dbdumptime:"=%" call "%root%\mars.cmd" export
:finish
call :echo Scheduler stopping.
goto :end

:post-update
if exist "%root%\%1" goto :exec
call :echo Post-update script %1 does not exist.
goto :eof
:exec
call :echo Starting post-update script %1...
start /b /wait cmd /c "%root%\%1">>%logfile% 2>&1
call :echo Post-update script finished. E:%errorlevel%
del /q "%root%\%1" >nul 2>&1
goto :eof

:echo
echo %time% %*
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
