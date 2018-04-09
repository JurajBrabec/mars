@echo off
REM MARS 4.1 UPDATE SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
setlocal enabledelayedexpansion
pushd %~dp0
set "folder=%~dp0"
:find-root
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :find-root
set "root=%folder%"
set "logfile=%root%\logs\init.log"
:init
call :echo DB Initialization started
call "%root%\mars.cmd" stop all
if "%errorlevel%" equ "0" goto :remove
call :echo Error %errorlevel% stopping services.
goto :end
:remove
call :echo Removing files...
rmdir /q /s "%root%\data" >nul 2>&1
if "%errorlevel%" equ "0" goto :copy
call :echo Error %errorlevel% removing files.
goto :end
:copy
call :echo Copying files...
mkdir "%root%\data" >nul 2>&1
echo . >"%root%\data\init.sql"
xcopy /e /i /k /y "%root%\bin\db\data" "%root%\data">nul 2>&1
if "%errorlevel%" equ "0" goto :start
call :echo Error %errorlevel% copying files.
goto :end
:start
call "%root%\mars.cmd" start db
if "%errorlevel%" equ "0" goto :create
call :echo Error %errorlevel% starting DB service.
goto :end
:create
call :echo Creating database...
"%root%\bin\7z.exe" e -so "%root%\cmd\init\init.7z" create.sql | "%root%\bin\db\bin\mysql.exe" --user=root --password="" >>"%logfile%"
if "%errorlevel%" equ "0" goto :configure
call :echo Error %errorlevel% creating database.
goto :end
:configure
call :echo Configuring database...
"%root%\bin\7z.exe" e -so "%root%\cmd\init\init.7z" config.sql | "%root%\bin\db\bin\mysql.exe" --user=root >>"%logfile%"
if "%errorlevel%" equ "0" goto :nbu
call :echo Error %errorlevel% configuring database.
goto :end
:nbu
call :echo Creating NBU database...
"%root%\bin\7z.exe" e -so "%root%\cmd\init\init.7z" init.sql>"%root%\data\init.sql"
"%root%\bin\7z.exe" e -so "%root%\cmd\init\init.7z" nbu.sql | "%root%\bin\db\bin\mysql.exe" --user=root >>"%logfile%"
if "%errorlevel%" equ "0" goto :http
call :echo Error %errorlevel% creating NBU database.
:http
call "%root%\mars.cmd" start http
if "%errorlevel%" equ "0" goto :finish
call :echo Error %errorlevel% starting HTTP service.
goto :end
:finish
call :echo DB Initialization finished.
goto :end

:echo
echo %time% %*
echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
