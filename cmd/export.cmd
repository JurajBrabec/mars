@echo off
REM MARS 4.1 EXPORT SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
set db=mars40
pushd %~dp0
FOR /f "delims=" %%i IN ("%~dp0..") DO SET "root=%%~fi"
set "logfile=%root%\logs\export-%db%.log"
:export
call :echo Starting DB export of database '%db%'...
"%root%\bin\db\bin\mysqldump.exe" --no-create-info --flush-logs --flush-privileges --log-error="%logfile%" --replace --databases %db% | "%root%\bin\7z.exe" u -si%db%.sql "%root%\cmd\export\%db%.7z" >nul 2>&1
dir "%root%\cmd\export\%db%.7z" | findstr %db%>>%logfile%
call :echo DB export of database '%db%' finished.
goto :end

:echo
echo %date% %time% %*
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
