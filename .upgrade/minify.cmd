@echo off
setlocal enabledelayedexpansion
:SETUP
if "%folder%" equ "" set "folder=%~dp0"
for /f "delims=" %%i in ("!folder!\..\") do set "folder=%%~fi"
if not exist "!folder!\cmd" goto :SETUP
set "root=%folder%"
if "%root:~-1%"=="\" set root=%root:~0,-1%
:EXECUTE
if not exist "%root%\bin\php\php.exe" goto :PHP_MISSING
%root%\bin\php\php.exe %root%\.upgrade\minify\minify.php %*
goto :END
:PHP_MISSING
echo Fatal: PHP executable is not found in '%root%\bin\php' folder.
goto :END
:END
