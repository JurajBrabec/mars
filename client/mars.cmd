@echo off
setlocal enabledelayedexpansion
pushd %~dp0
set _mars_home=%~dp0
 set _php_home=%_mars_home%bin\php\
for /f "tokens=1,* delims== " %%i in ('type "%_mars_home%config.ini"') do if "%%i" EQU "PHP_HOME" set _php_home=%%j\
set _php_home=%_php_home:"=%
if not exist "%_mars_home%log" mkdir "%_mars_home%log"
if not exist "%_mars_home%tmp" mkdir "%_mars_home%tmp"
if exist "%_mars_home%.update" call :UPDATE
:EXECUTE
if not exist "%_php_home%php.exe" goto :PHP_MISSING
%_php_home%\php.exe %_mars_home%mars.php %*
if exist "%_mars_home%.update" call :UPDATE
goto :END
:PHP_MISSING
echo Fatal: PHP executable is not found in '%_php_home%' folder.
goto :END
:UPDATE
echo Updating file(s)...
xcopy /s /e /i /y "%_mars_home%.update" "%_mars_home%"
if "%errorlevel%" neq "0" goto :ERROR
rmdir /s /q "%_mars_home%.update"
echo Done.
goto :EOF
:ERROR
echo Error %errorlevel% during update.
goto :EOF
:END
endlocal
popd
