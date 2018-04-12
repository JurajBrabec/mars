@echo off
REM MARS 4.1 UPDATE SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
pushd %~dp0
:setup
if "%folder%" equ "" set "folder=%~dp0"
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :setup
set "root=%folder%"
if "%root:~-1%"=="\" set root=%root:~0,-1%
for /f %%i in (files\www\build) do set build=%%i
set "logfile=%root%\logs\update-%build%.log"
if exist "%logfile%" del /q "%logfile%"
:begin
call :echo MARS update #%build% starting...
for /f %%i in (%root%\www\build) do call :check %%i
goto :end

:check
set _new=0
for /f "delims=. tokens=1-3" %%a in ("%1") do (
	for /f "delims=. tokens=1-3" %%d in ("%build%") do (
		if %%d gtr %%a set _new=1
		if %%e grt %%b set _new=1
		if %%f geq %%c set _new=1
	)
)
if "%_new%" equ "1" goto :ok
call :echo Cannot continue. MARS already on build #%1
set errorlevel=1
goto :eof
:ok
call :echo Build #%1 found
set result=0
rem if "%result%" equ "0" call :service stop http
rem if "%result%" equ "0" call :service stop db
if "%result%" equ "0" call :delete
if "%result%" equ "0" call :copy
rem if "%result%" equ "0" call :service start db
rem if "%result%" equ "0" call :service start http
if "%result%" equ "0" call :sql
if "%result%" equ "0" goto :finish
call :echo Error %result%. MARS update #%build% NOT successful.
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
xcopy /e /i /k /y files "%root%" >>"%logfile%" 2>&1
set result=%errorlevel%
goto :eof

:sql
if not exist .sql goto :eof
call :echo Executing SQL...
"%root%\bin\db\bin\mysql.exe" -u root -D mysql <.sql >>"%logfile%" 2>&1
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
