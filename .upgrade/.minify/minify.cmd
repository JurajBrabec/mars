@echo off
setlocal enabledelayedexpansion
set _mars_home=%~dp0..\..\
set _php_home=%_mars_home%bin\php\
set _php_home=%_php_home:"=%
:EXECUTE
if not exist "%_php_home%php.exe" goto :PHP_MISSING
%_php_home%php.exe %_mars_home%.upgrade\.minify\minify.php %*
goto :END
:PHP_MISSING
echo Fatal: PHP executable is not found in '%_php_home%' folder.
goto :END
:END
