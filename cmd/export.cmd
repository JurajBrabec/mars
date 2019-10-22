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
	call :database-export MARS30 %2
	goto :end
)
if /i "%1" equ "mars40" (
	call :database-export MARS40 %2
	goto :end
)
if /i "%1" equ "mars41" (
	call :database-export MARS41 %2
	goto :end
)
if /i "%1" equ "mars_backup" (
	call :database-export MARS_BACKUP %2
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
if "%2" equ "" goto :set-tables
set tables=%2
goto :export-execute
:set-tables
call :echo Starting DB export of database '%db%'...
if "%db%" equ "MARS30" set tables=config_cellservers config_customers config_mediaservers ^
config_retentions config_scheduler config_settings config_timeperiods config_timers ^
dataprotector_clients dataprotector_copylists dataprotector_devices dataprotector_libraries ^
dataprotector_locked_objects dataprotector_media dataprotector_objects dataprotector_omnistat ^
dataprotector_omnistat_devices dataprotector_omnistat_objects dataprotector_pools ^
dataprotector_sessions dataprotector_session_devices dataprotector_session_media ^
dataprotector_session_objects dataprotector_specifications mars_log mars_queue
if "%db%" equ "MARS40" set tables=config_customers config_reports config_schedules ^
config_settings config_timeperiods config_towers ^
bpdbjobs_report bpdbjobs_summary bpflist_backupid bpimmedia bpimmedia_frags ^
bpplclients bppllist_clients bppllist_policies bppllist_schedules bpretlevel ^
nbu_policy_tower_customer nbstl vault_item_xml vault_xml
if "%db%" equ "MARS41" set tables=config_customers config_owners config_settings config_timeperiods config_towers ^
dp_clients dp_copylists dp_devices dp_libraries dp_media dp_objects dp_pools ^
dp_sessions dp_session_devices dp_session_media dp_session_objects dp_specifications ^
mars_backups mars_devices mars_hosts mars_ids mars_links mars_lists ^
mars_log mars_media mars_objects mars_status mars_strings ^
nbu_clients nbu_files nbu_images nbu_image_frags nbu_jobs ^
nbu_policies nbu_retlevels nbu_schedules nbu_strings nbu_slps nbu_vaults
if "%db%" equ "MARS_BACKUP" set tables=
:export-execute
echo.>"%root%\tmp\.export"
del /q "%root%\cmd\dump\%db%.7z" >nul 2>&1
if "%tables%" equ "" (
	call :export-database %db%
) else (
	for %%i in (%tables%) do call :export-table %db% %%i
)
del "%root%\tmp\.export" >nul 2>&1
dir /-c "%root%\cmd\dump\%db%.7z" | findstr %db%>>"%logfile%"
call :echo DB export of database '%db%' finished.
goto :eof

:export-table
call :echo Exporting table %1\%2...
"%root%\bin\db\bin\mysqldump.exe" --no-create-info --order-by-primary --replace --flush-logs --log-error="%logfile%" %1 %2 | "%root%\bin\7z\7z.exe" u -si%2.sql "%root%\cmd\dump\%1.7z" >nul 2>&1
goto :EOF

:export-database
call :echo Exporting DB %1...
"%root%\bin\db\bin\mysqldump.exe" --no-create-info --order-by-primary --replace --flush-logs --log-error="%logfile%" %1 | "%root%\bin\7z\7z.exe" u -si%1.sql "%root%\cmd\dump\%1.7z" >nul 2>&1
goto :EOF

:echo
echo %time% %*
if "%logfile%" neq "" echo %date% %time% %*>>"%logfile%"
goto :eof

:end
popd
exit /b %errorlevel%
