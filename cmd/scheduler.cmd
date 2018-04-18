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
:begin
call :echo Scheduler starting...
echo.>"%root%\tmp\.scheduler"
if exist "%root%\www\nbu\php.php" "%root%\bin\php\php.exe" "%root%\www\nbu\php.php">>"%logfile%" 2>&1
if exist "%root%\www\dp\index.php" "%root%\bin\php\php.exe" "%root%\www\dp\index.php" s=scheduler>>"%logfile%" 2>&1
del "%root%\tmp\.scheduler" >nul 2>&1
if not exist "%root%\.updates" goto :database-dump
:post-updates
echo.>"%root%\tmp\.update"
for /f %%i in (%root%\.updates) do call :post-update %%i
del /q "%root%\.updates" >nul 2>&1
del "%root%\tmp\.update" >nul 2>&1
:database-dump
set dbdumptime="16:00"
for /f "tokens=1,2 delims== " %%i in ("%root%\conf\config.ini") do if /i "%%i" equ "db_dump_time" set dbdumptime=%%j
if "%starttime%" equ "%dbdumptime:"=%" ( 
	call "%root%\mars.cmd" export
)
:finish
call :echo Scheduler finished.
goto :end

:post-update
if not exist "%root%\%1" (
	call :echo Post-update script %1 does not exist.
	goto :eof
)
call :echo Starting post-update script %1...
start /b /wait cmd /c "%root%\%1">>"%logfile%" 2>&1
call :echo Post-update script finished. E:%errorlevel%
del /q "%root%\%1" >nul 2>&1
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
