@echo off
REM MARS 4.1 QRS AUDIT PART#2 SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly.
goto :end
:setup
set build=vpc-qrs-audit
set "logfile=%root%\logs\%build%.log"
:begin
call :echo MARS %build% part#2 starting...
call :echo Executing SQL...
"%root%\bin\db\bin\mysql.exe" -u root -D mysql <.sql >>"%logfile%" 2>&1
if "%errorlevel%" neq "0" goto :error
call :echo Importing QRS...
"%root%\bin\db\bin\mysql.exe" -u root -D audit <qrs.sql >>"%logfile%" 2>&1
if "%errorlevel%" neq "0" goto :error
call :echo Importing comments...
"%root%\bin\db\bin\mysql.exe" -u root -D audit <comments.sql >>"%logfile%" 2>&1
if "%errorlevel%" neq "0" goto :eof
call :echo Executing audit...
"%root%\bin\db\bin\mysql.exe" -u root -D audit --execute "call procedure_execute('juraj.brabec@dxc.com');" >>"%logfile%" 2>&1
if "%errorlevel%" neq "0" goto :error
goto :finish
:error
call :echo Error %result%. MARS %build% failed.
set errorlevel=%result%
goto :end
:finish
del /q *.sql >nul 2>&1
call :echo MARS %build% part#2 successful.
goto :end

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>%logfile%
goto :eof

:end
popd
if "%result%" neq "" exit /b %result%
exit /b %errorlevel%
