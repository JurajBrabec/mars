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
for /f %%i in (%root%\build) do call :update %%i
goto :end

:update
call :echo Build #%1 found
set result=0
rem if "%result%" equ "0" call :service stop http
rem if "%result%" equ "0" call :service stop db
rem if "%result%" equ "0" call :delete
rem if "%result%" equ "0" call :copy
rem if "%result%" equ "0" call :service start db
rem if "%result%" equ "0" call :service start http
if "%result%" equ "0" call :sql
if "%result%" equ "0" goto :finish
call :echo Error %result%. MARS %build% NOT successful.
set errorlevel=%result%
goto :eof
:finish
call :echo MARS update #%build% successful.
goto :eof

:delete
call :echo Deleting file(s)...
rem del /q "%root%\tmp\*.tmp" >>"%logfile%" 2>&1
rem rmdir /s /q "%root%\www\phpmyadmin" >>"%logfile%" 2>&1
set result=%errorlevel%
goto :eof

:copy
call :echo Copying file(s)...
rem xcopy /e /i /k /y files "%root%" >>"%logfile%" 2>&1
set result=%errorlevel%
goto :eof

:sql
if not exist .sql goto :eof
call :echo Executing SQL...
"%root%\bin\db\bin\mysql.exe" -u root -D mysql <.sql >>"%logfile%" 2>&1
set result=%errorlevel%
if "%result%" neq "0" goto :eof
call :echo Importing QRS...
"%root%\bin\db\bin\mysql.exe" -u root -D audit <qrs.sql >>"%logfile%" 2>&1
set result=%errorlevel%
if "%result%" neq "0" goto :eof
call :echo Importing comments...
"%root%\bin\db\bin\mysql.exe" -u root -D audit <comments.sql >>"%logfile%" 2>&1
set result=%errorlevel%
if "%result%" neq "0" goto :eof
call :echo Executing audit...
"%root%\bin\db\bin\mysql.exe" -u root -D audit --execute "call procedure_execute();" >>"%logfile%" 2>&1
set result=%errorlevel%
goto :eof

:service
call "%root%\mars.cmd" %1 %2 2>&1
set result=%errorlevel%
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
