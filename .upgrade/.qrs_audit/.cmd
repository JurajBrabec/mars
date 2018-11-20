@echo off
REM MARS 4.1 UPDATE SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
:setup
if "%folder%" equ "" set "folder=%~dp0"
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :setup
set "root=%folder%"
if "%root:~-1%"=="\" set root=%root:~0,-1%
set build=vpc-qrs-audit
set "logfile=%root%\logs\update-%build%.log"
if exist "%logfile%" del /q "%logfile%"
:begin
call :echo MARS %build% starting...
for /f %%i in (%root%\build) do call :echo Build #%%i found
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
"%root%\bin\db\bin\mysql.exe" -u root -D audit --execute "call procedure_execute();" >>"%logfile%" 2>&1
if "%errorlevel%" neq "0" goto :error
call :echo MARS %build% successful.
goto :eof
:error
call :echo Error %errorlevel%. MARS %build% failed.
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
exit /b %errorlevel%
