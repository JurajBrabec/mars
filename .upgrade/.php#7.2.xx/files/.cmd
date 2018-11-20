@echo off
REM MARS 4.1 PHP UPDATE PART#2 SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly.
goto :end
:setup
for /f "tokens=2" %%i in ('%root%\bin\php\php.exe -v ^|findstr cli') do set prevversion=%%i
for /f %%i in ('dir /b "php-*.zip"') do set filename=%%i
for /f "tokens=2 delims=-" %%i in ("%filename%") do set build=%%i
set "logfile=%root%\logs\update_php_%build%.log"
:begin
call :echo MARS PHP update %build% part#2 starting...
call "%root%\mars.cmd" stop http 2>&1
set result=%errorlevel%
if "%result%" equ "0" call :remove
if "%result%" equ "0" call :extract
if "%result%" equ "0" call :vcredist
if "%result%" equ "0" (
	call "%root%\mars.cmd" start http 2>&1
	if %errorlevel% gtr 0 set result=%errorlevel%
)
if "%result%" equ "0" goto :finish
:error
call :echo Error %result%. MARS PHP update %build% failed.
set errorlevel=%result%
goto :end
:finish
del /q "%filename%" >nul 2>&1
call :echo MARS PHP update %build% part#2 successful.
goto :end

:remove
call :echo Removing previous PHP version %prevversion%...
ren "%root%\bin\php" php.%prevversion% >nul 2>&1
set result=%errorlevel%
goto :eof

:extract
call :echo Extracting archive %filename%...
set exclude=-x^^!extras -x^^!lib -x^^!php.ini*
"%root%\bin\7z\7z.exe" x "%filename%" -r -aoa -bd -bb0 -y -o"%root%\bin\php" !exclude!>>"%logfile%" 2>&1
set result=%errorlevel%
if "%errorlevel%" equ "0" rmdir /s /q "%root%\bin\php.%prevversion%" >nul 2>&1
if exist "%root%\bin\php.%prevversion%" call :echo Unable to delete PHP folder, renaming it to PHP.%prevversion%. Delete the folder manually after reboot...
goto :eof

:vcredist
call :echo Installing Microsoft Visual C++ Redistributable Components...
start /wait /d "%root%\bin" vc_redist.x64.exe /repair /passive /norestart 
if %errorlevel% equ 3010 ver > nul
if %errorlevel% gtr 0 call :echo Error %errorlevel% installing Microsoft Visual C++ Redistributable Components.
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>%logfile%
goto :eof

:end
popd
if "%result%" neq "" exit /b %result%
exit /b %errorlevel%
