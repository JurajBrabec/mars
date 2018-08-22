@echo off
setlocal enabledelayedexpansion
pushd %~dp0
set _mars_home=%~dp0
 set _php_home=%_mars_home%bin\php\
for /f "tokens=1,* delims== " %%i in ('type "%_mars_home%config.ini"') do if "%%i" EQU "PHP_HOME" set _php_home=%%j\
set _php_home=%_php_home:"=%
:EXECUTE
if not exist "%_php_home%php.exe" goto :PHP_MISSING
%_php_home%\php.exe %_mars_home%test.php %*
goto :END
:PHP_MISSING
echo Fatal: PHP executable is not found in '%_php_home%' folder.
goto :END
:END
popd
