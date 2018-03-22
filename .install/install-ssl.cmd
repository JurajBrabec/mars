@echo off
REM MARS 4.1 INSTALL FILE
REM DON'T MODIFY ANYTHING BELOW THIS LINE -------------------------------------------------------------------------------
REM
setlocal enabledelayedexpansion
pushd %~dp0
call install.cmd SSL
endlocal
popd
exit /b %errorlevel%
