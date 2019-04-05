<?php

/*
 * MARS 4.1 PHP CODE
 * build 4.1.17 @ 2018-10-25 04:17
 * * rewritten from scratch
 */

require_once implode( DIRECTORY_SEPARATOR, array( __DIR__, 'inc', 'os.php' ) );
require_once os( )->path( array( __DIR__, 'inc', 'database.php' ) );
require_once os( )->path( array( __DIR__, 'inc', 'nbu_commands.php' ) );

#-----------------------------------

function convert_config( ) {
	try {
		$filename = os( )->path( 'config.ini' );
		file_exists( $filename . '.default' ) && unlink ( $filename . '.default' );
		$content = os( )->read_file( $filename );
		$oldconfig = explode( PHP_EOL, $content );
		$newconfig = array( );
		$i = 0;
		$modified = false;
		while ( $i < count( $oldconfig ) ) {
			$add = $remove = $modify = false;
			$line = $oldconfig[ $i ];
			if ( strpos( $line, '=' ) ) {
				list( $key, $value ) = explode( '=', $line );
				$key = trim( $key ); $value = trim( $value );
				switch ( $key ) {
//MODIFY					case '%KEY%' : $new_value = '%VALUE%'; $modify = $value <> $new_value; break;
					case 'THREADS' : $new_value = '4'; $modify = $value <> $new_value; break;
				}
				if ( $modify ) { 
					$line = sprintf( '%s=%s', str_pad( $key, 24 ), $new_value );
					$newconfig[ ] = $line;
					logfile( display( 'Modified line "' . $oldconfig[ $i ] . '" to "' . $line . '"' ) );
				}
			}
//REMOVE			preg_match( '/^%KEY%/', $line ) && $remove = true;
			$remove && logfile( display( 'Removed line ' . $line ) ) || $newconfig[ ] = $line;
//ADD			!preg_match( '/%KEY%/', $content ) && preg_match( '/^%AFTER%/', $line ) && $add = true && $line = str_pad( '%KEY%', 24 ) . '="%VALUE%"';
			$add && logfile( display( 'Added line ' . $line ) ) && $newconfig[ ] = $line;
			$modified = $modified || $modify || $remove || $add;
			$i++;
		}
		$modified && os( )->write_file( $filename, $newconfig ) && logfile( display( 'Config file successfuly converted.' ) );
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function on_finish_callback( $threads, $thread ) {
	try {
		$name = $threads->put( $thread );
		handler( nbu( )->get( $name, $threads->get( $name ) ) );
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function handler( $object ) {
	if ( !is_object( $object ) ) return false;
	try {
		logfile( display( sprintf( 'Report: %s', get_class( $object ) ) ) );
		$sql = $object->SQL( get_class( $object ) );
		if ( $sql === false ) $sql = array( );
		logfile( display( 'SQLs:' . count( $sql ) ) );
		$i = 1;
		foreach( $sql as $s ) {
			$result = database( )->execute_query( $s );
			$result !=0 && logfile( display( 'SQL ' . $i . ' result:' . $result ) );
			if ( $result == -1 ) {
				logfile( display( ' Insert ID:' . database( )->insert_id( ) ) );
				logfile( display( ' Rows:' . database( )->row_count( ) ) );
				logfile( display( ' Info:' . database( )->query_info( ) ) );
				logfile( display( ' Error:' . database( )->error( ) ) );
				logfile( display( ' Message:' . database( )->message( ) ) );
				logfile( display( ' Duration:' . database( )->duration( ) ) );
				debug( 'SQL ' . $i . ': ' . $s );
			}
			$i++;
		}
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function update( ) {
	try {
		global $ini;
		$url = sprintf( 'http://%s/nbu/client/update.zip', $ini[ 'DB_HOST' ] );
		$root = dirname( __FILE__ );
		$tmp = os( )->path( array( $root, 'tmp' ) );
		$build = os( )->path( array( $root, 'build' ) );
		$old_etag = file_exists( $build ) ? file_get_contents( $build ) : '';
		debug( timestamp( sprintf( 'Getting client update file "%s".', $url ) ) );
		$headers = get_headers( $url );
		debug( timestamp( sprintf( 'Result: "%s".', $headers[ 0 ] ) ) );
		if ( $headers[ 0 ] == 'HTTP/1.1 200 OK' ) {
			sscanf( $headers[ 4 ], 'ETag: "%[^"]', $etag );
			debug( timestamp( sprintf( 'ETag: "%s" (previously "%s").', $etag, $old_etag ) ) );
			if( $etag != $old_etag ) {
				logfile( display( sprintf( 'Updating client to build "%s"...', $etag ) ) );
				file_exists( $tmp ) || mkdir( $tmp );
				$update = os( )->path( array( $root, 'tmp', $etag . '.zip' ) );
				debug( timestamp( sprintf( 'Downloading client update to file "%s"...', $update ) ) );
				if ( file_put_contents( $update, fopen( $url, 'r' ) ) ) {
					$zip = new ZipArchive;
					if ( $zip->open( $update ) === TRUE ) {
						debug( timestamp( sprintf( 'Unzipping to "%s"...', $root ) ) );
						$zip->extractTo( $root );
						$zip->close( );
						unlink( $update );
						file_put_contents( $build, $etag );
						logfile( display( 'Update finished successfuly.' ) );
					} else {
						logfile( display( sprintf( 'Error opening ZIP file "%s".', $update ) ) );
					}
				} else {
					logfile( display( sprintf( 'Error downloading ZIP file "%s".', $url ) ) );
				}
			}
		}
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function nbu2sm9( ) {
	try {
		global $ini;
		$ini[ 'NBU2SM9_FILE' ] = 'nbu_mars_sm9.txt';
		$ini[ 'NBU2SM9_DELIMITER' ] = ';;';
		is_dir( $ini[ 'NBU2SM9_PATH' ] ) || mkdir( $ini[ 'NBU2SM9_PATH' ], 0777, true );
		$file_name = os( )->path( array( $ini[ 'NBU2SM9_PATH' ] , $ini[ 'NBU2SM9_FILE' ] ) );
		$where = file_exists( $file_name ) ? sprintf( "where ended>'%s'", date( 'Y-m-d H:i:s', filemtime( $file_name )  ) ) : '';
		$sql = sprintf( 'select * from nbu_tickets %s;', $where );
		logfile( display( 'NBU2SM9 tickets:' . database( )->execute_query( $sql ) ) );
		$file = new basic_log_file( $file_name );
		foreach( database( )->rows( ) as $row ) {
			$NBU2SM9_TXT_FIELDS = array(
				'Ended'				=> trim( $row[ 'ended' ] )
				,'MasterServer'		=> trim( $row[ 'masterserver' ] )
				,'Priority'			=> trim( $row[ 'priority' ] )
				,'Message'			=> trim( $row[ 'message' ] )
				,'JobID'			=> trim( $row[ 'jobid' ] )
				,'JobType'			=> trim( $row[ 'jobtype' ] )
				,'Subtype'			=> trim( $row[ 'subtype' ] )
				,'State'			=> trim( $row[ 'state' ] )
				,'Started'			=> trim( $row[ 'started' ] )
				,'Elapsed'			=> trim( $row[ 'elapsed' ] )
				,'Tries'			=> trim( $row[ 'tries' ] )
				,'Status'			=> trim( $row[ 'status' ] )
				,'Description'		=> trim( $row[ 'description' ] )
				,'Tower'			=> trim( $row[ 'tower' ] )
				,'Customer'			=> trim( $row[ 'customer' ] )
				,'Client'			=> trim( $row[ 'client' ] )
				,'Policy'			=> trim( $row[ 'policy' ] )
				,'PolicyType'		=> trim( $row[ 'policytype' ] )
				,'Schedule'			=> trim( $row[ 'schedule' ] )
				,'ScheduleType'		=> trim( $row[ 'scheduletype' ] )
			);
			file_exists( $file_name ) || $file->write( implode( $ini[ 'NBU2SM9_DELIMITER' ], array_keys( $NBU2SM9_TXT_FIELDS ) ) );
			$file->write( implode( $ini[ 'NBU2SM9_DELIMITER' ], $NBU2SM9_TXT_FIELDS ) );
		}
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function nbu2esl( ) {
	try {
		global $ini;
		$NBU2ESL_TXT = 'esl_omni_obcheck.txt';
		$NBU2ESL_CLIENT_TXT = 'esl_omni_obcheck_client.txt';
		$NBU2ESL_TXT_FIELDS = array(
			'System Name'			=> ''
			,'Backup Method'		=> 'NetBackup'
			,'Backup Name'			=> ''
			,'Backup Scheduler'		=> 'NetBackup'
			,'Tape Check Time'		=> '15:00'
			,'Backup Start Time'		=> ''
			,'Backup Type'			=> ''
			,'Service Tier'			=> '98%'
			,'Scheduling Mon'		=> ''
			,'Scheduling Tue'		=> ''
			,'Scheduling Wed'		=> ''
			,'Scheduling Thu'		=> ''
			,'Scheduling Fri'		=> ''
			,'Scheduling Sat'		=> ''
			,'Scheduling Sun'		=> ''
			,'Scheduling On Demand'	=> '1'
			,'Restartable?'			=> 'Auto Recovery'
			,'Restart Window'		=> '12 h'
			,'Backup Device'			=> ''
			,'Backup Retention'		=> ''
			,'Recovery Instructions'	=> ''
			,'Comments'				=> ''
#			,'Ticket Postpone Time'	=> ''
#			,'Backup Reportable'		=> '1'
		);
		$NBU2ESL_CLIENT_TXT_FIELDS = array( 
			'System Name'			=> ''
			,'Backup Method'		=> 'NetBackup'
			,'Backup Name'			=> ''
			,'Client System Name'	=> ''
		);
		$LINE1 = '#Automatic upload for backup information to ESL';
		$LINE2 = '#Generated by MARS 4.1 @ ' . date( 'd.m.Y H:i' );

		is_dir( $ini[ 'NBU2ESL_PATH' ] ) || mkdir( $ini[ 'NBU2ESL_PATH' ], 0777, true );

		$sql = "select * from nbu_esl;";
		logfile( display( 'NBU2ESL policies:' . database( )->execute_query( $sql ) ) );
		$file_name = os( )->path( array( $ini[ 'NBU2ESL_PATH' ], $NBU2ESL_TXT ) );
		file_exists( $file_name ) && unlink( $file_name );
		$file = new basic_log_file( $file_name );
		$file->write( $LINE1 );
		$file->write( $LINE2 );
		$file->write( implode( ',', array_keys( $NBU2ESL_TXT_FIELDS ) ) );
		$start_keys = array( 'mon_start','tue_start','wed_start','thu_start','fri_start','sat_start','sun_start' );
		foreach( database( )->rows( ) as $row ) {
			$start_times = array_unique( array_values( array_filter( array_intersect_key( $row, array_flip( $start_keys ) ) ) ) );
			sort( $start_times );
			$NBU2ESL_TXT_FIELDS[ 'System Name' ] = $row[ 'masterserver' ];
			$NBU2ESL_TXT_FIELDS[ 'Backup Name' ] = $row[ 'name' ];
			$NBU2ESL_TXT_FIELDS[ 'Backup Start Time'] = count( $start_times ) == 0 ? '11:11' : $start_times[ 0 ];
			$NBU2ESL_TXT_FIELDS[ 'Backup Type' ] = $row[ 'backuptype' ] == 'Full' ? 'Full' : 'Incr';
			$NBU2ESL_TXT_FIELDS[ 'Scheduling Mon' ] = empty( $row[ 'mon_start' ] ) ? '0' : '1';
			$NBU2ESL_TXT_FIELDS[ 'Scheduling Tue' ] = empty( $row[ 'tue_start' ] ) ? '0' : '1';
			$NBU2ESL_TXT_FIELDS[ 'Scheduling Wed' ] = empty( $row[ 'wed_start' ] ) ? '0' : '1';
			$NBU2ESL_TXT_FIELDS[ 'Scheduling Thu' ] = empty( $row[ 'thu_start' ] ) ? '0' : '1';
			$NBU2ESL_TXT_FIELDS[ 'Scheduling Fri' ] = empty( $row[ 'fri_start' ] ) ? '0' : '1';
			$NBU2ESL_TXT_FIELDS[ 'Scheduling Sat' ] = empty( $row[ 'sat_start' ] ) ? '0' : '1';
			$NBU2ESL_TXT_FIELDS[ 'Scheduling Sun' ] = empty( $row[ 'sun_start' ] ) ? '0' : '1';
			$NBU2ESL_TXT_FIELDS[ 'Backup Device' ] = $row[ 'res' ];
			$NBU2ESL_TXT_FIELDS[ 'Backup Retention' ] = preg_replace( '/(ay|eek|onth|ear)s?/i', '', $row[ 'retentionlevel' ] );
			$file->write( '"' . implode( '","', $NBU2ESL_TXT_FIELDS ) . '"' );
		}
		
		$sql = "select * from nbu_esl_client;";
		logfile( display( 'NBU2ESL clients:' . database( )->execute_query( $sql ) ) );
		$file_name = os( )->path( array( $ini[ 'NBU2ESL_PATH' ], $NBU2ESL_CLIENT_TXT ) );
		file_exists( $file_name ) && unlink( $file_name );
		$file = new basic_log_file( $file_name );
		$file->write( $LINE1 );
		$file->write( $LINE2 );
		$file->write( implode( ',', array_keys( $NBU2ESL_CLIENT_TXT_FIELDS ) ) );
		foreach( database( )->rows( ) as $row ) {
			$NBU2ESL_CLIENT_TXT_FIELDS [ 'System Name' ] = $row[ 'masterserver' ];
			$NBU2ESL_CLIENT_TXT_FIELDS [ 'Backup Name' ] = $row[ 'name' ];
			$NBU2ESL_CLIENT_TXT_FIELDS [ 'Client System Name' ] = $row[ 'client' ];
			$file->write( '"' . implode( '","', $NBU2ESL_CLIENT_TXT_FIELDS ) . '"' );
		}
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function read_files( $interval ) {
	global $threads;
	try {	
		$types = '0,13,40';
		$sql = 'SELECT DISTINCT id.backupid FROM ( ';
		$sql .= 'SELECT j.masterserver,j.backupid,j.started FROM bpdbjobs_report j ';
		$sql .= sprintf( 'WHERE j.policytype IN (%s) AND j.backupid IS NOT NULL ', $types );
		$sql .= 'AND j.jobid<>j.parentjob ';
		$sql .= sprintf( 'AND j.started>unix_timestamp(NOW()-INTERVAL %s HOUR) ', $interval );
		$sql .= 'UNION ALL ';
		$sql .= 'SELECT i.masterserver,i.backupid,i.backup_time AS started FROM bpimagelist i ';
		$sql .= sprintf( 'WHERE i.client_type IN (%s) AND i.backupid IS NOT NULL ', $types );
		$sql .= sprintf( 'AND i.backup_time>unix_timestamp(NOW()-INTERVAL %s HOUR) ', $interval );
		$sql .= ') id ';
		$sql .= 'LEFT JOIN bpflist_backupid f ON (f.masterserver=id.masterserver AND f.backupid=id.backupid) ';
		$sql .= 'WHERE f.backupid IS NULL ';
		$sql .= 'ORDER BY id.started;';
		logfile( display( 'Backup ID`s:' . database( )->execute_query( $sql ) ) );
		foreach( database( )->rows( ) as $row ) {
			bpflist_backupid( $row[ 'backupid' ] )->execute( $threads );
//			try { handler( bpflist_backupid( $row[ 'backupid' ] )->execute( ) ); } catch ( exception $e ) { exception_handler( $e ); }
		}
		$threads->execute( );
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function due( $optitem, $iniitem = '' ) {
	global $opt, $ini, $time;
	$match = $iniitem == '' ? true : preg_match( '/' . $ini[ $iniitem ] . '/', $time );
	return ( empty( $opt ) && $match ) || isset( $opt[ $optitem ] );
}

function exception_handler( $e ) {
	$message = sprintf( 'Exception: "%s"', $e->getMessage( ) );
	logfile( timestamp( display( $message ) ) );
	return true;
}

function shutdown_function( ) {
	$e = error_get_last( );
	if ( empty( $e ) ) return true;
	$message = sprintf( 'Exiting with %s [%s] "%s" in "%s" on line #%s', 
		array_search( $e[ 'type' ], get_defined_constants( ) ), $e[ 'type' ], $e[ 'message' ], $e[ 'file' ], $e[ 'line' ] );
	logfile( timestamp( $message ) );
	return true;
}

error_reporting( E_ALL );
register_shutdown_function( 'shutdown_function' );
set_exception_handler( 'exception_handler' );
display( '------' );
try {
	if ( !os( )->php( '7.2' ) ) throw new exception( sprintf( os::PHP_UNSUPPORTED, os::php( ) ) );
	$lock = new lock_file( os( )->path( 'mars.lock' ) );
	logfile( new log_file( os( )->path( array( 'log', 'mars.log' ) ) ) )->max_size( 10 * 1000 * 1000 );
	debug( new debug_log_file( os( )->path( array( 'log', 'mars.debug.log' ) ) ) )->max_size( 10 * 1000 * 1000 );
	convert_config( );
	$ini = array_change_key_case( parse_ini_file( os( )->path( 'config.ini' ), FALSE ), CASE_UPPER );
	date_default_timezone_set( $ini[ 'TIME_ZONE' ] );
	debug( )->enabled( $ini[ 'DEBUG' ] );
	$opts = array( 'esl', 'clients', 'files', 'images', 'jobs', 'policies', 'retlevel', 'sm9', 'summary', 'update', 'vault', 'hours::', 'days::', 'time::'  );
	$opt = array_change_key_case( array_map( 'strtoupper', getopt( '', $opts ) ), CASE_UPPER );
	if ( isset( $opt[ 'TIME' ] ) ) { $time = $opt[ 'TIME' ]; unset( $opt[ 'TIME' ] ); }
	empty( $time ) && $time = date( 'H:i' );
	if ( isset( $opt[ 'HOURS' ] ) ) { $hours = $opt[ 'HOURS' ]; unset( $opt[ 'HOURS' ] ); }
	if ( empty( $hours ) ) switch( $time ) {
		case '12:45': $hours = 24; break;
		case '06:45': $hours = 12; break;
		case '18:45': $hours = 6; break;
		default : $hours = 2; break;
	}
	if ( isset( $opt[ 'DAYS' ] ) ) { $days = $opt[ 'DAYS' ]; unset( $opt[ 'DAYS' ] ); }
	if ( empty( $days ) ) switch( $time ) {
		case '12:15': $days = 7; break;
		case '07:15':
		case '17:15': $days = 3; break;
		default : $days = 1; break;
	}
	debug( 100, timestamp( sprintf( 'START TIME %s', $time ) ) );
	database( new mysqli_database( $ini[ 'DB_HOST' ], $ini[ 'DB_USER' ], $ini[ 'DB_PWD' ], $ini[ 'DB_NAME' ] ) );
	$threads = new multi_thread( $ini[ 'THREADS' ] );
	$threads->root( os( )->path( 'tmp' ) );
	$threads->on_finish_callback( 'on_finish_callback' );
	nbu( )->home( $ini[ 'NBU_BIN_HOME' ] );
	nbu( )->tmp( os( )->path( 'tmp' ) );
	if ( $lock->lock( true ) ) {
		empty( $opt ) || logfile( display( 'Executing ' . implode( ',', array_keys( $opt ) ) ) );
		if ( due( 'UPDATE' ) ) update( );
		try { 
			handler( bpdbjobs_summary( )->execute( ) );
			if ( due( 'POLICIES', 'NBUPOLICIES_TIME' ) ) bppllist_policies( )->execute( $threads );
			if ( due( 'CLIENTS', 'NBUCLIENTS_TIME' ) ) bpplclients( )->execute( $threads );
			if ( due( 'JOBS', 'NBUJOBS_TIME' ) ) bpdbjobs_report( $days )->execute( $threads );
			if ( due( 'IMAGES', 'NBUIMAGES_TIME' ) ) bpimagelist_hoursago( $hours )->execute( $threads );
			$threads->execute( );
			if ( due( 'FILES', 'NBUFILES_TIME' ) ) read_files( $hours );
			if ( due( 'VAULT', 'NBUVAULT_TIME' ) ) try { handler( vault_xml( os( )->path( array ( $ini[ 'NBU_DATA_HOME' ], 'db', 'vault' ) ) )->execute( ) ); } catch ( exception $e ) { exception_handler( $e ); }
			if ( due( 'RETLEVEL', 'NBURETLEVEL_TIME' ) ) try { handler( bpretlevel( )->execute( ) ); } catch ( exception $e ) { exception_handler( $e ); }
			if ( due( 'ESL', 'NBU2ESL_TIME' ) ) nbu2esl( );
			if ( due( 'SM9', 'NBU2SM9_TIME' ) ) nbu2sm9( );
		} catch ( exception $e ) { exception_handler( $e ); }
		$lock->lock( false );
	} else {
		logfile( display( 'Another instance in progress.' ) );
	}
} catch ( exception $e ) { exception_handler( $e ); }
display( '------' );
display( sprintf( 'Memory used: %sMb',round( os( )->memory_peak( ) /1000000, 1 ) ) );
display( sprintf( 'Duration: %sms', os( )->duration( ) ) );
debug( 100, timestamp( 'STOP' ) );
