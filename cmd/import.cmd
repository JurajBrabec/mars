@echo off
REM MARS 4.1 DATABASE IMPORT SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :end
:setup
set "logfile=%root%\logs\import.log"
:begin
if /i "%1" equ "mars30" (
	call :database-import MARS30 %2
	goto :end
)
if /i "%1" equ "mars40" (
	call :database-import MARS40 %2
	goto :end
)
if /i "%1" equ "mars41" (
	call :database-import MARS41 %2
	goto :end
)
if /i "%1" equ "mars_backup" (
	call :database-import MARS_BACKUP %2
	goto :end
)
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
set table=%2
if "%q%" neq "" goto :import-check
:import-prompt
echo WARING: You are about to import %db% database from dump.
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
echo.>"%root%\tmp\.import"
call :echo Starting DB import of '%db%.sql' dump ...
call :echo Importing DB %db% ...
"%root%\bin\db\bin\mysql.exe" --database=%db% <"%root%\cmd\dump\%db%.sql" >>"%logfile%"
call :echo Import of '%db%.sql' dump finished (E:%errorlevel%).
del "%root%\tmp\.import" >nul 2>&1
goto :eof
:import_7z
echo.>"%root%\tmp\.import"
call :echo Starting DB import of '%db%.7z' dump ...
if "%table%" equ "" (
	for /f "tokens=6" %%i in ('"%root%\bin\7z\7z.exe" l -ba %root%\cmd\dump\%db%.7z') do call :import_7z_table %db% %%i
) else (
	call :import_7z_table %db% %table%.sql
)
call :echo Import of '%db%.7z' dump finished.
del "%root%\tmp\.import" >nul 2>&1
goto :eof
:import_7z_table
call :echo Importing table %1\%2 ...
"%root%\bin\7z\7z.exe" e -so "%root%\cmd\dump\%1.7z" %2 | "%root%\bin\db\bin\mysql.exe" --database=%1 >>"%logfile%"
call :echo Import of table %1\%2 finished (E:%errorlevel%). 
goto :eof 

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
exit /b %errorlevel%
