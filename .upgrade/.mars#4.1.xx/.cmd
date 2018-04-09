@echo off
setlocal enabledelayedexpansion
REM MARS 4.1 UPDATE SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
pushd %~dp0
set "folder=%~dp0"
:find-root
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :find-root
set "root=%folder%"
:update
for /f %%i in (files\www\build) do set build=%%i
set logfile=%root%\logs\update-%build%.log
if exist "%logfile%" del /q %logfile%
call :echo MARS update to build #%build% starting...
for /f %%i in (%root%\www\build) do call :check-build %%i
goto :end

:check-build
set _new=0
for /f "delims=. tokens=1-3" %%a in ("%1") do (
	for /f "delims=. tokens=1-3" %%d in ("%build%") do (
		if %%d GTR %%a set _new=1
		if %%e GTR %%b set _new=1
		if %%f GEQ %%c set _new=1
	)
)
if "%_new%" EQU "1" goto :continue
call :echo Cannot continue. MARS already on build #%1
set errorlevel=1
goto :eof
:continue
call :echo Build #%1 found
set result=0
rem if "%result%" equ "0" call :stop-http
rem if "%result%" equ "0" call :stop-db
rem if "%result%" equ "0" call :delete
if "%result%" equ "0" call :copy
rem if "%result%" equ "0" call :start-db
rem if "%result%" equ "0" call :start-http
if "%result%" equ "0" call :sql
if "%result%" equ "0" goto :finish
call :echo Error %result%. Update NOT successful.
set errorlevel=%result%
goto :eof
:finish
call :echo Update successful.
goto :eof

:delete
call :echo Deleting file(s)...
rem del /q %root%\tmp\*.tmp >>%logfile% 2>&1
rem rmdir /s /q %root%\www\phpmyadmin >>%logfile% 2>&1
set result=%errorlevel%
goto :eof

:copy
call :echo Copying file(s)...
xcopy /e /i /k /y files %root%>>%logfile% 2>&1
set result=%errorlevel%
goto :eof

:sql
if not exist .sql goto :EOF
call :echo Executing SQL...
if exist "%root%\mysql\bin\mysql.exe" (
	"%root%\mysql\bin\mysql.exe" --defaults-file="%root%\mysql\dump.cnf" -D mysql <.sql >>%logfile% 2>&1
) else (
	"%root%\bin\db\bin\mysql.exe" -u root -D mysql <.sql >>%logfile% 2>&1
)
set result=%errorlevel%
goto :eof

:stop-http
call "%root%\mars.cmd" stop http %logfile% 2>&1
set result=%errorlevel%
goto :eof

:stop-db
call "%root%\mars.cmd" stop db %logfile% 2>&1
set result=%errorlevel%
goto :eof

:start-db
call "%root%\mars.cmd" start db %logfile% 2>&1
set result=%errorlevel%
goto :eof

:start-http
call "%root%\mars.cmd" start http %logfile% 2>&1
set result=%errorlevel%
goto :eof

:echo
echo %time% %*
echo %date% %time% %*>>%logfile%
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
