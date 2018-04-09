@echo off
setlocal enabledelayedexpansion
REM MARS 4.1 UPDATE PART#2 SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
pushd %~dp0
set "root=%~dp0"
for /f "tokens=2" %%i in ('%root%\bin\php\php.exe -v ^|findstr cli') do set prevversion=%%i
for /f %%i in ('dir /b "%root%\php-*.zip"') do set filename=%%i
for /f "tokens=2 delims=-" %%i in ("%filename%") do set build=%%i
set "logfile=%root%\logs\update_php_%build%.log"
:start
call :echo MARS PHP update %build% part#2 starting...
call "%root%\mars.cmd" stop http %logfile% 2>&1
set result=%errorlevel%
if "%result%" equ "0" call :remove
if "%result%" equ "0" call :extract
if "%result%" equ "0" call :vcredist
if "%result%" equ "0" call "%root%\mars.cmd" start http %logfile% 2>&1
set result=%errorlevel%
if "%result%" equ "0" goto :finish
call :echo Error %result%. MARS PHP update %build% NOT successful.
goto :end
:finish
del /q "%root%\%filename%" >nul 2>&1
call :echo MARS PHP update %build% part#2 successful.
goto :end

:remove
call :echo Removing previous PHP version %prevversion%...
ren "%root%\bin\php" php.%prevversion% >nul 2>&1
set result=%errorlevel%
rmdir /s /q "%root%\bin\php.%prevversion%" >nul 2>&1
if exist "%root%\bin\php.%prevversion%" call :echo Unable to delete PHP folder, renaming it to PHP.%prevversion%. Delete the folder manually after reboot...
goto :eof

:extract
call :echo Extracting %filename%...
set exclude=-x^^!extras -x^^!lib -x^^!php.ini*
"%root%\bin\7z.exe" x "%root%\%filename%" -r -aoa -bd -bb0 -y -o"%root%\bin\php" !exclude!>>"%logfile%" 2>&1
set result=%errorlevel%
goto :eof

:vcredist
call :echo Installing Microsoft Visual C++ Redistributable Components...
start /wait /d "%root%bin" vcredist_x86.exe /repair /passive /norestart /showfinalerror
if %errorlevel% gtr 0 call :echo Error %errorlevel% installing Microsoft Visual C++ Redistributable Components.
goto :eof

:echo
echo %date% %time% %*>>%logfile%
echo %time% %*
goto :eof

:end
set %errorlevel%=%result%
endlocal
popd
exit /b %result%
