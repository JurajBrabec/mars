@echo off
REM MARS 4.1 DATABASE EXPORT SCRIPT
REM (C) 2018 Juraj Brabec, DXC.technology
REM DON'T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

setlocal enabledelayedexpansion
pushd %~dp0
if "%root%" neq "" goto :setup
echo Do not run this file directly, use MARS.CMD launcher.
goto :end
:setup
set "logfile=%root%\logs\export.log"
:begin
if /i "%1" equ "mars30" (
	call :database-export MARS30
	goto :end
)
if /i "%1" equ "mars40" (
	call :database-export MARS40
	goto :end
)
if /i "%1" equ "mars_backup" (
	call :database-export MARS_BACKUP
	goto :end
)
if "%1" equ "" (
	call :database-export MARS30
	call :database-export MARS40
	call :database-export MARS_BACKUP
	goto :end
)
:usage
echo MARS %build% DATABASE EXPORT SCRIPT
echo USAGE: MARS export [{database}]
goto :end

:database-export
set db=%1
call :echo Starting DB export of database '%db%'...
if "%db%" equ "MARS30" (
	set config_tables=config_cellservers config_customers config_mediaservers config_retentions config_scheduler config_settings config_timeperiods config_timers
	set data_tables=dataprotector_clients dataprotector_copylists dataprotector_devices dataprotector_libraries dataprotector_locked_objects dataprotector_media dataprotector_objects dataprotector_omnistat dataprotector_omnistat_devices dataprotector_omnistat_objects dataprotector_pools dataprotector_sessions dataprotector_session_devices dataprotector_session_media dataprotector_session_objects dataprotector_specifications mars_log mars_queue
)
if "%db%" equ "MARS40" (
	set config_tables=config_customers config_reports config_schedules config_settings config_timeperiods config_towers
	set data_tables=bpdbjobs_report bpdbjobs_summary bppllist_clients bppllist_policies bppllist_schedules bpretlevel nbu_policy_tower_customer vault_item_xml vault_xml
)
if "%db%" equ "MARS_BACKUP" (
	set config_tables=
	set data_tables=
)
echo.>"%root%\tmp\.export"
"%root%\bin\db\bin\mysqldump.exe" --no-create-info --order-by-primary --replace --flush-logs --log-error="%logfile%" %db% %config_tables% %data_tables% | "%root%\bin\7z\7z.exe" u -si%db%.sql "%root%\cmd\dump\%db%.7z" >nul 2>&1
del "%root%\tmp\.export" >nul 2>&1
dir /-c "%root%\cmd\dump\%db%.7z" | findstr %db%>>"%logfile%"
call :echo DB export of database '%db%' finished.
goto :eof

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
endlocal
popd
exit /b %errorlevel%
