@echo off
REM MARS 4.1 IMPORT SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
set db=mars40
pushd %~dp0
FOR /f "delims=" %%i IN ("%~dp0..") DO SET "root=%%~fi"
set "logfile=%root%\logs\import-%db%.log"
:import
if exist "%root%\cmd\export\%db%.sql" goto :import_sql
if exist "%root%\cmd\export\%db%.7z"  goto :import_7z
call :echo Error: Files '%db%.sql' or '%db%.7z' not found in folder '%root%\cmd\export'.
goto :end

:import_sql
call :echo Importing '%db%.sql' dump ...
"%root%\bin\db\bin\mysql.exe" <"%root%\cmd\export\%db%.sql" >>%logfile%
call :echo Import of '%db%.sql' dump finished.
goto :end

:import_7z
call :echo Importing '%db%.7z' dump ...
"%root%\bin\7z.exe" e -so "%root%\cmd\export\%db%.7z" | "%root%\bin\db\bin\mysql.exe" >>%logfile%
call :echo Import of '%db%.7z' dump finished.
goto :end

:echo
echo %time% %*
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
