@echo off
REM MARS 4.1 DATABASE INITIALIZATION SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :end
:setup
set "logfile=%root%\logs\init.log"
:begin
if /i "%1" equ "start" goto :service-start
if /i "%1" equ "create" goto :database-create
if /i "%1" equ "configure" goto :database-configure
if /i "%1" equ "nbu" goto :database-nbu
if /i "%1" equ "dp" goto :database-dp
:init-prompt
if "%q%" neq "" goto :prompt-check
echo WARNING: You are about to initialize MARS database to default state.
set /p q=To approve and continue, type 'APPROVE' (Exit):
:prompt-check
if "%q%" equ "APPROVE" goto :init-start
echo Init process was not approved. Exiting.
goto :end
:init-start
call :echo DB Initialization started...
:service-stop
call "%root%\mars.cmd" stop db
if "%errorlevel%" equ "0" goto :files-remove
call :echo Error %errorlevel% stopping DB service.
goto :end
:files-remove
call :echo Removing files...
rmdir /q /s "%root%\data" >nul 2>&1
if "%errorlevel%" equ "0" goto :data-init
call :echo Error %errorlevel% removing files.
goto :end
:data-init
call :echo Initializing database...
"%root%\bin\db\bin\mysql_install_db.exe" -d "%root%\data" >>"%logfile%" 2>&1
echo . >>"%logfile%"
if "%errorlevel%" equ "0" goto :data-init-finish
call :echo Error %errorlevel% initializing database.
goto :end
:data-init-finish
del /q "%root%\data\my.ini" >nul 2>&1
rmdir /q /s "%root%\data\test" >nul 2>&1
echo. >"%root%\data\init.sql"
:service-start
call "%root%\mars.cmd" start db
if "%errorlevel%" equ "0" goto :database-create
call :echo Error %errorlevel% starting DB service.
goto :end
:database-create
call :echo Creating MARS database...
rem set zipfile="%root%\cmd\install\init.zip"
rem "%root%\bin\7z\7z.exe" e -so %zipfile% create.sql | "%root%\bin\db\bin\mysql.exe" --user=root --password="" >>"%logfile%"
"%root%\bin\db\bin\mysql.exe" --user=root --password="" -D mysql <"%root%\cmd\install\sql\create.sql" >>"%logfile%" 2>&1
if "%errorlevel%" equ "0" goto :database-configure
call :echo Error %errorlevel% creating MARS database.
goto :end
:database-configure
call :echo Configuring MARS database...
rem "%root%\bin\7z\7z.exe" e -so %zipfile% config.sql | "%root%\bin\db\bin\mysql.exe" --user=root >>"%logfile%"
"%root%\bin\db\bin\mysql.exe" -u root -D mysql <"%root%\cmd\install\sql\config.sql" >>"%logfile%" 2>&1
if "%errorlevel%" equ "0" goto :database-nbu
call :echo Error %errorlevel% configuring MARS database.
goto :end
:database-nbu
call :echo Creating NBU database...
rem "%root%\bin\7z\7z.exe" e -so %zipfile% nbu.sql | "%root%\bin\db\bin\mysql.exe" --user=root >>"%logfile%"
"%root%\bin\db\bin\mysql.exe" -u root -D mysql <"%root%\cmd\install\sql\nbu.sql" >>"%logfile%" 2>&1
if "%errorlevel%" equ "0" goto :database-dp
call :echo Error %errorlevel% creating NBU database.
goto :end
:database-dp
call :echo Creating DP database...
rem "%root%\bin\7z\7z.exe" e -so %zipfile% dp.sql | "%root%\bin\db\bin\mysql.exe" --user=root >>"%logfile%"
"%root%\bin\db\bin\mysql.exe" -u root -D mysql <"%root%\cmd\install\sql\dp.sql" >>"%logfile%" 2>&1
if "%errorlevel%" equ "0" goto :finish
call :echo Error %errorlevel% creating DP database.
:finish
rem "%root%\bin\7z\7z.exe" e -so %zipfile% init.sql>"%root%\data\init.sql"
copy /y "%root%\cmd\install\sql\init.sql" "%root%\data" >nul 2>&1
call :echo DB Initialization finished.
goto :end

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
exit /b %errorlevel%
