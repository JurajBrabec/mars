@echo off
REM MARS 4.1 UPDATE PART#2 SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE █████████████████████████████████████████████████████████████████████████████
REM © 2018 Juraj Brabec, DXC.technology
setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly.
goto :end
:setup
for /f "tokens=4 delims=/ " %%i in ('%root%\bin\http\bin\httpd.exe -v ^|findstr version') do set prevversion=%%i
for /f %%i in ('dir /b "%root%\httpd-*.zip"') do set filename=%%i
for /f "tokens=2 delims=-" %%i in ("%filename%") do set build=%%i
set "logfile=%root%\logs\update_http_%build%.log"
:begin
call :echo MARS HTTP (Apache) update %build% part#2 starting...
call "%root%\mars.cmd" stop http 2>&1
set result=%errorlevel%
if "%result%" equ "0" call :remove
if "%result%" equ "0" call :extract
if "%result%" equ "0" call :vcredist
if "%result%" equ "0" (
	call "%root%\mars.cmd" start http 2>&1
	set result=%errorlevel%
)
if "%result%" equ "0" goto :finish
call :echo Error %result%. MARS HTTP (Apache) update %build% NOT successful.
set %errorlevel%=%result%
goto :end
:finish
del /q "%root%\%filename%" >nul 2>&1
call :echo MARS HTTP (Apache) update %build% part#2 successful.
goto :end

:remove
call :echo Removing previous HTTP (Apache) version %prevversion%...
ren "%root%\bin\http" http.%prevversion% >nul 2>&1
set result=%errorlevel%
rmdir /s /q "%root%\bin\http.%prevversion%" >nul 2>&1
if exist "%root%\bin\http.%prevversion%" call :ECHO Unable to delete HTTP folder, renaming it to HTTP.%prevversion%. Delete the folder manually after reboot...
goto :eof

:extract
call :echo Extracting %filename%...
set exclude=-x^^!readme_first.html -x^^!*.pl -x^^!*\include\ -x^^!*\lib\ -x^^!*\logs\install.log
"%root%\bin\7z\7z\.exe" x "%root%\%filename%" -r -aoa -bd -bb0 -y -o"%root%\bin\http.tmp" !exclude!>>"%logfile%" 2>&1
if "%errorlevel%" equ "0" for /d %%i in ("%root%\bin\http.tmp\*") do rename "%%i" http >nul 2>&1
if "%errorlevel%" equ "0" move "%root%\bin\http.tmp\http" "%root%\bin" >nul 2>&1
if "%errorlevel%" equ "0" rmdir /s /q "%root%\bin\http.tmp" >nul 2>&1
set result=%errorlevel%
goto :eof

:vcredist
call :echo Installing Microsoft Visual C++ Redistributable Components...
start /wait /d "%root%\bin" vcredist_x86.exe /repair /passive /norestart /showfinalerror
if %errorlevel% gtr 0 call :echo Error %errorlevel% installing Microsoft Visual C++ Redistributable Components.
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
