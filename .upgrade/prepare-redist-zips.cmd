@echo off
setlocal enabledelayedexpansion
REM MARS 4.1 BINARY REDISTRIBUTION SCRIPT
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
pushd %~dp0
set "folder=%~dp0"
:find-root
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :find-root
set "root=%folder%"
for /f %%i in ('dir /b *.zip') do "%root%\bin\7z.exe" d -r %%i *.pdb *.h


:end
endlocal
popd
exit /b %errorlevel%
