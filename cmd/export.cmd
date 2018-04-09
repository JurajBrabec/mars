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
set "logfile=%root%\logs\export-%db%.log"
set db=mars40
:export
call :echo Starting DB export of database '%db%'...
"%root%\bin\db\bin\mysqldump.exe" --no-create-info --flush-logs --flush-privileges --log-error="%logfile%" --replace --databases %db% | "%root%\bin\7z.exe" u -si%db%.sql "%root%\cmd\export\%db%.7z" >nul 2>&1
dir "%root%\cmd\export\%db%.7z" | findstr %db%>>%logfile%
call :echo DB export of database '%db%' finished.
goto :end

:echo
echo %time% %*
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
