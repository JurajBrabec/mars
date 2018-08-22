@echo off
REM MARS 4.1 DB UPDATE PART#2 SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly.
goto :end
:setup
for /f "tokens=3 delims=- " %%i in ('%root%\bin\db\bin\mysqld.exe -V') do set prevversion=%%i
for /f %%i in ('dir /b "%root%\mariadb-*.zip"') do set filename=%%i
for /f "tokens=2 delims=-" %%i in ("%filename%") do set build=%%i
set "logfile=%root%\logs\update_db_%build%.log"
:begin
call :echo MARS DB (MariaDB) update %build% part#2 starting...
call "%root%\mars.cmd" stop db 2>&1
set result=%errorlevel%
if "%result%" equ "0" call :remove
if "%result%" equ "0" call :extract
if "%result%" equ "0" call :rename
if "%result%" equ "0" call :move
if "%result%" equ "0" (
	call "%root%\mars.cmd" start db 2>&1
	if %errorlevel% gtr 0 set result=%errorlevel%
)
if "%result%" equ "0" call :update
if "%result%" equ "0" goto :finish
call :echo Error %result%. MARS DB (MariaDB) update %build% NOT successful.
set errorlevel=%result%
goto :end
:finish
del /q "%root%\%filename%" >nul 2>&1
call :echo MARS DB (MariaDB) update %build% part#2 successful.
goto :end

:remove
call :echo Removing previous DB version %prevversion%...
ren "%root%\bin\db" db.%prevversion% >nul 2>&1
set result=%errorlevel%
goto :eof

:extract
call :echo Extracting archive %filename%...
set exclude=-x^^!*.ini -x^^!*.jar -x^^!*.lib -x^^!*.pdb -x^^!*.pl -x^^!*\data\test\ -x^^!*\include\ -x^^!*\lib\debug\ -x^^!*\share\*.sql"
"%root%\bin\7z\7z.exe" x "%root%\%filename%" -r -aoa -bd -bb0 -y -o"%root%\bin\db.tmp" !exclude!>>"%logfile%" 2>&1
set result=%errorlevel%
ping -n 3 localhost >nul 2>&1
goto :eof
:rename
call :echo Renaming subfolders...
for /d %%i in ("%root%\bin\db.tmp\mariadb-*") do rename "%%i" db >nul 2>&1
set result=%errorlevel%
goto :eof
:move
call :echo Moving DB...
move "%root%\bin\db.tmp\db" "%root%\bin" >nul 2>&1
if "%errorlevel%" equ "0" rmdir /s /q "%root%\bin\db.tmp" >nul 2>&1
set result=%errorlevel%
if "%errorlevel%" equ "0" rmdir /s /q "%root%\bin\db.%prevversion%" >nul 2>&1
if exist "%root%\bin\db.%prevversion%" call :echo Unable to delete DB folder, renaming it to DB.%prevversion%. Delete the folder manually after reboot...
goto :eof

:update
call :echo Upgrading SQL...
"%root%\bin\db\bin\mysql_upgrade.exe" -u root >>%logfile% 2>&1
set result=%errorlevel%
if not exist "%root%\.sql" goto :eof
call :echo Executing SQL...
"%root%\bin\db\bin\mysql.exe" -u root -D mysql <"%root%\.sql" >>%logfile% 2>&1
set result=%errorlevel%
del /q "%root%\.sql"
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
if "%result%" neq "" exit /b %result%
exit /b %errorlevel%
