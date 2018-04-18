@echo off
REM MARS 4.1 DATABASE EXPORT SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :end
:setup
set "logfile=%root%\logs\export.log"
:begin
if /i "%1" equ "mars30" (
	call :database-export MARS30
	goto :end
)
if /i "%1" equ "mars40" (
	call :database-export MARS40
	goto :end
)
if /i "%1" equ "mars_backup" (
	call :database-export MARS_BACKUP
	goto :end
)
if "%1" equ "" (
	call :database-export MARS30
	call :database-export MARS40
	call :database-export MARS_BACKUP
	goto :end
)
:usage
echo MARS %build% DATABASE EXPORT SCRIPT
echo USAGE: MARS export [{database}]
goto :end

:database-export
set db=%1
call :echo Starting DB export of database '%db%'...
echo.>"%root%\tmp\.export"
"%root%\bin\db\bin\mysqldump.exe" --no-create-info --flush-logs --flush-privileges --log-error="%logfile%" --replace --compact --databases %db% | "%root%\bin\7z\7z.exe" u -si%db%.sql "%root%\cmd\dump\%db%.7z" >nul 2>&1
dir /-c "%root%\cmd\dump\%db%.7z" | findstr %db%>>"%logfile%"
del "%root%\tmp\.export" >nul 2>&1
call :echo DB export of database '%db%' finished.
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
