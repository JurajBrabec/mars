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
if "%1" equ "mars30" call :import mars30
if "%1" equ "mars40" call :import mars40
if "%1" equ "mars_backup" call :import mars_backup
if "%1" neq "" goto :end
call :import mars30
call :import mars40
call :import mars_backup
goto :end

:import
set db=%1
set "logfile=%root%\logs\import-%db%.log"
if exist "%root%\cmd\export\%db%.sql" goto :import_sql
if exist "%root%\cmd\export\%db%.7z"  goto :import_7z
call :echo Error: Files '%db%.sql' or '%db%.7z' not found in folder '%root%\cmd\export'.
goto :eof

:import_sql
call :echo Importing '%db%.sql' dump ...
"%root%\bin\db\bin\mysql.exe" <"%root%\cmd\export\%db%.sql" >>"%logfile%"
call :echo Import of '%db%.sql' dump finished.
goto :end

:import_7z
call :echo Importing '%db%.7z' dump ...
"%root%\bin\7z.exe" e -so "%root%\cmd\export\%db%.7z" | "%root%\bin\db\bin\mysql.exe" >>"%logfile%"
call :echo Import of '%db%.7z' dump finished.
goto :end

:echo
echo %time% %*
echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
