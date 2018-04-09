@echo off
REM MARS 4.1 EXPORT SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
pushd %~dp0
set "folder=%~dp0"
:find-root
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :find-root
set "root=%folder%"
if "%1" equ "mars30" call :export mars30
if "%1" equ "mars40" call :export mars40
if "%1" equ "mars_backup" call :export mars_backup
if "%1" neq "" goto :end
call :export mars30
call :export mars40
call :export mars_backup
goto :end

:export
set db=%1
set "logfile=%root%\logs\export-%db%.log"
call :echo Starting DB export of database '%db%'...
"%root%\bin\db\bin\mysqldump.exe" --no-create-info --flush-logs --flush-privileges --log-error="%logfile%" --replace --databases %db% | "%root%\bin\7z.exe" u -si%db%.sql "%root%\cmd\export\%db%.7z" >nul 2>&1
dir "%root%\cmd\export\%db%.7z" | findstr %db%>>"%logfile%"
call :echo DB export of database '%db%' finished.
goto :eof

:echo
echo %time% %*
echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
