@echo off
REM MARS 4.1 DATABASE IMPORT SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE █████████████████████████████████████████████████████████████████████████████
REM © 2018 Juraj Brabec, DXC.technology
setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :usage
:setup
set "logfile=%root%\logs\import.log"
:begin
if /i "%1" equ "mars30" (
	call :database-import MARS30
	goto :end
)
if / i"%1" equ "mars40" {
	call :database-import MARS40
	goto :end
}
if /i "%1" equ "mars_backup" (
	call :database-import MARS_BACKUP
	goto :end
}
if "%1" equ "" (
	call :database-import MARS30
	call :database-import MARS40
	call :database-import MARS_BACKUP
	goto :end
)
:usage
echo MARS %build% DATABASE IMPORT SCRIPT
echo USAGE: MARS import [{database}]
goto :end

:database-import
set db=%1
if "%q%" neq "" goto :import-check
:import-prompt
echo [91mWARING: You are about to import %db% database from dump.[0m
set /p q=To approve and continue, type 'APPROVE' (Exit):
:import-check
if "%q%" equ "APPROVE" goto :import-start
echo Import process of database %db% was not approved. Exiting.
goto :eof
:import-start
if exist "%root%\cmd\dump\%db%.sql" goto :import_sql
if exist "%root%\cmd\dump\%db%.7z"  goto :import_7z
call :echo Error: Files '%db%.sql' or '%db%.7z' not found in folder '%root%\cmd\dump'.
goto :eof
:import_sql
call :echo Importing '%db%.sql' dump ...
"%root%\bin\db\bin\mysql.exe" <"%root%\cmd\dump\%db%.sql" >>"%logfile%"
call :echo Import of '%db%.sql' dump finished.
goto :eof
:import_7z
call :echo Importing '%db%.7z' dump ...
"%root%\bin\7z\7z.exe" e -so "%root%\cmd\dump\%db%.7z" | "%root%\bin\db\bin\mysql.exe" >>"%logfile%"
call :echo Import of '%db%.7z' dump finished.
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
