@echo off
setlocal enabledelayedexpansion
REM MARS 4.1 UPDATE PART#1 SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
pushd %~dp0
set "folder=%~dp0"
:find-root
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :find-root
set "root=%folder%"
:prepare
for /f %%i in ('dir /b files\mariadb-*.zip') do set filename=%%i
for /f "tokens=2 delims=-" %%i in ("%filename%") do set build=%%i
set "logfile=%root%\logs\update_db_%build%.log"
if not exist "%root%\logs" mkdir "%root%\logs">>%logfile%
if exist %logfile% del /q %logfile%
if "%scheduler%" equ "1" goto :start
tasklist | findstr php.exe >nul 2>&1
if "%errorlevel%" equ "0" set scheduler=1
:start
call :echo MARS DB (MariaDB) update %build% part#1 starting...
if "%scheduler%" equ "1" call :echo (started from scheduler)
call :echo Copying file(s)...
for /f %%i in ("%~dp0.") do ren files\.cmd %%~nxi.cmd >nul 2>&1
xcopy /e /i /y files "%root%">>nul 2>&1
if "%errorlevel%" neq "0" goto :error
:finish
if not exist files\*.cmd goto :ok
for /f %%i in ('dir /b files\*.cmd') do set postupdate=%%i
if "%scheduler%" equ "1" goto :scheduler
:post-update
call :echo Starting post-update script...
start /b /wait cmd /c "%root%\%postupdate%" 2>&1
if "%errorlevel%" neq "0" goto :error
del /q "%root%\%postupdate%" >nul 2>&1
call :echo Post-update script finished.
goto :ok
:scheduler
echo %postupdate%>>"%root%\.updates"
:ok
call :echo MARS DB (MariaDB) update %build% part#1 successful.
goto :end

:error
call :echo Error %errorlevel%. MARS DB (MariaDB) update %build% NOT successful.
goto :end

:echo
echo %date% %time% %*>>%logfile%
echo %time% %*
goto :EOF

:end
endlocal
popd
exit /b %errorlevel%
