@echo off
REM MARS 4.1 IMPORT SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
pushd %~dp0
set "folder=%~dp0"
:find-root
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :find-root
set "root=%folder%"
set "logfile=%root%\logs\import-%db%.log"
set db=mars40
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
