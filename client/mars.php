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
function help( ) {
	display( 'USAGE: MARS [-ACTION] [-h[ours]=HH] [-d[ays]=DD] [-t[ime]=HH:MM]' );
	display( 'Configuration related actions:' );
	display( "\tclients\t\treads clients" );
	display( "\tpolicies\treads policies and schedules" );
	display( "\tretlevels\treads retention levels" );
	display( "\tslps\t\treads SLP`s" );
	display( "\tvaults\t\treads vaults" );
	display( 'Data related actions:' );
	display( "\tjobs [-d[ays]=DD]\treads jobs for last DD days" );
	display( "\tallimages\treads all backup images" );
	display( "\timages [-d[ays]=DD]\treads backup images for last DD days" );
	display( "\tfiles [-h[ours]=HH]\treads files for last HH hours" );
	display( 'Other actions:' );
	display( "\tesl\t\texport configuration to ESL *.txt files" );
	display( "\tsm9\t\texport tickets to SM9 nbmom.log file" );
	display( "\tupdate\t\tupdate MARS and exit" );
	display( 'Parameters:' );
	display( "\td[ays]=DD\tdefault 1 day, 3 days at 7:15, 7 days at 11:15" );
	display( "\th[ours]=HH\tdefault 1 hour, 3 hours at 7:45, 7 hours at 11:45" );
	display( "\tt[ime]=HH:MM\tMARS can be run for a specific time, default is current time" );
}

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
				$key = trim( $key ); $value = trim( $value ); $new_value = $value;
				switch ( $key ) {
//MODIFY					case '%KEY%' : $new_value = '%VALUE%'; break;
							case 'NBUIMAGES_TIME' : $new_value = '"10:15"'; break;
							case 'NBUFILES_TIME' : $new_value = '"..:45"'; break;
				}
				$modify = $value <> $new_value;
				if ( $modify ) { 
					$line = sprintf( '%s=%s', str_pad( $key, 24 ), $new_value );
					logfile( display( 'Modified line "' . $oldconfig[ $i ] . '" to "' . $line . '"' ) );
				}
			}
//REMOVE			preg_match( '/^%KEY%/', $line ) && $remove = true;
			preg_match( '/^NBU2SM9_X_STATUS/', $line ) && $remove = true;
			preg_match( '/^NBU2SM9_X_JOBTYPE/', $line ) && $remove = true;
			$remove && logfile( display( 'Removed line ' . $line ) ) || $newconfig[ ] = $line;
//ADD			!preg_match( '/%KEY%/', $content ) && preg_match( '/^%AFTER%/', $line ) && $add = true && $line = str_pad( '%KEY%', 24 ) . '="%VALUE%"';
			!preg_match( '/NBU2SM9_LOGROT_TIME/', $content ) && preg_match( '/^NBU2SM9_PATH/', $line ) && $add = true && $line = str_pad( 'NBU2SM9_LOGROT_TIME', 24 ) . '="12:00"';
			!preg_match( '/NBU2SM9_LOG_HISTORY/', $content ) && preg_match( '/^NBU2SM9_LOGROT_TIME/', $line ) && $add = true && $line = str_pad( 'NBU2SM9_LOG_HISTORY', 24 ) . '=7';
			!preg_match( '/NBU2SM9_FILTER_JOBTYPES/', $content ) && preg_match( '/^NBU2SM9_LOG_HISTORY/', $line ) && $add = true && $line = str_pad( 'NBU2SM9_FILTER_JOBTYPES', 24 ) . '="Image cleanup"';
			!preg_match( '/NBU2SM9_FILTER_STATUSES/', $content ) && preg_match( '/^NBU2SM9_FILTER_JOBTYPES/', $line ) && $add = true && $line = str_pad( 'NBU2SM9_FILTER_STATUSES', 24 ) . '="150"';
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
			debug( 100, timestamp( sprintf( 'RESULT: %s', $result ) ) );
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

function ini_default( $key, $value ) {
	global $ini;
	isset( $ini[ $key ] ) || $ini[ $key ] = $value;
}

function nbu2sm9( ) {
	function filter( $filter, $value ) {
		return ( !empty( $filter ) and preg_match( sprintf( '/^(%s)$/i', $filter ), $value ) );
	}
	try {
		global $ini;
		$debug_level = '303';
		ini_default( 'NBU2SM9_PATH', 'tmp' );
		ini_default( 'NBU2SM9_LOGROT_TIME', '12:00' );
		ini_default( 'NBU2SM9_LOG_HISTORY', 7 );

		if ( stripos( $ini[ 'NBU2SM9_PATH' ], 'backupmon' ) > 0 ) {
			ini_default( 'NBU2SM9_FILE', 'nbmon.log' );
			ini_default( 'NBU2SM9_LINE', 'RM-TT-Major-<@.MGrp>-<@.EType>-Policy:<*.POLICY> Policy:<*.POLICY> failed with JobID:<*.JOBID> <*.MESSAGETEXT>' );
			ini_default( 'NBU2SM9_MESSAGETEXT', '<*.JOBTYPE> Type:<*.POLICYTYPE> State:<*.STATE> Status:<*.STATUS> Schedule:<*.SCHEDULE> ClientServer:<*.CLIENT> MasterServer:NULL' );
			$keymask = '<*.%s>';
		} else {
			ini_default( 'NBU2SM9_FILE', 'mars_mon.log' );
			ini_default( 'NBU2SM9_LINE', '<DATE>::<SEVERITY>::<ERRORCODE>::<MESSAGETEXT>::<EVENTNODE>::<EVENTTYPEINSTANCE>::<CORELLATIONKEY>');
			ini_default( 'NBU2SM9_MESSAGETEXT', '<JOBTYPE> Policy:<POLICY> failed with JobID:<JOBID> Type:<POLICYTYPE> State:<STATE> Status:<STATUS> Schedule:<SCHEDULE> ClientServer:<CLIENT> MasterServer:NULL' );
			$keymask = '<%s>';
		}
		ini_default( 'NBU2SM9_FILTER_JOBTYPES', 'Image cleanup' );
		ini_default( 'NBU2SM9_FILTER_POLICIES', '' );
		ini_default( 'NBU2SM9_FILTER_POLICYTYPES', '' );
 		ini_default( 'NBU2SM9_FILTER_STATUSES', '150' );
		
		is_dir( $ini[ 'NBU2SM9_PATH' ] ) || mkdir( $ini[ 'NBU2SM9_PATH' ], 0777, true );
		$file_name = os( )->path( array( $ini[ 'NBU2SM9_PATH' ] , $ini[ 'NBU2SM9_FILE' ] ) );
		$lffile_name = os( )->path( array( $ini[ 'NBU2SM9_PATH' ] , 'LastFailure.json' ) );
		$lastfailure = array( 'jobid' => 0, 'ended' => date( 'Y-m-d H:i:s', 0 ) );
		file_exists( $lffile_name ) && $lastfailure = json_decode( file_get_contents( $lffile_name ), true );
		file_exists( 'tmp\LastFailure.json' ) && $lastfailure = json_decode( file_get_contents( 'tmp\LastFailure.json' ), true ) && unlink( 'tmp\LastFailure.json' );
		$ended = $lastfailure[ 'ended' ];
		$jobid = $lastfailure[ 'jobid' ];
		$lines = 1;
		if ( file_exists( $file_name ) ) {
			$f = @fopen( $file_name, 'rb' );
			fseek( $f, -1, SEEK_END );
			if ( fread( $f, strlen( "\n" ) ) != "\n" ) $lines -= 1;
			$output = '';
			$chunk = '';
			while ( ftell( $f ) > 0 && $lines >= 0 ) {
				$seek = min( ftell( $f ), 64 );
				fseek( $f, -$seek, SEEK_CUR );
				$output = ( $chunk = fread( $f, $seek ) ) . $output;
				fseek( $f, -mb_strlen( $chunk, '8bit' ), SEEK_CUR );
				$lines -= substr_count( $chunk, "\n" );
			}
			while ( $lines++ < 0 ) {
				$output = substr( $output, strpos( $output, "\n" ) + 1 );
			}
			fclose( $f );
			$ended = '';
			$jobid = '';
			strpos( $output, '::' ) > 0 && $ended = substr( $output, 0, strpos( $output, '::' ) );
			preg_match( '/JobID:(\d+)/i', $output, $match ) && $jobid = $match[ 1 ];
		}
		debug( $debug_level, timestamp( sprintf( 'Last JobID %s', $jobid ) ) );
		if ( $jobid <> '' AND $ended == '' ) {
			$sql = sprintf( "select ended from nbu_tickets where masterserver='%s' and jobid='%s';", nbu( )->masterserver( ), $jobid );
			database( )->execute_query( $sql ) == 1 && $ended = database( )->rows( )[ 0 ][ 'ended' ];
			debug( $debug_level, timestamp( sprintf( 'JobID %s ended %s', $jobid, $ended ) ) );
		}
		$jobid == '' && $jobid = $lastfailure[ 'jobid' ];
		$ended == '' && $ended = $lastfailure[ 'ended' ];
		$difftime = strtotime( 'Today ' . $ini[ 'NBU2SM9_LOGROT_TIME' ] );
		if ( file_exists( $file_name ) && filemtime( $file_name ) < $difftime && time( ) > $difftime ) {
			file_exists( $file_name . '.' . $ini[ 'NBU2SM9_LOG_HISTORY' ] ) && unlink( $file_name . '.' . $ini[ 'NBU2SM9_LOG_HISTORY' ] );
			for ( $i = $ini[ 'NBU2SM9_LOG_HISTORY' ]; $i > 0; $i-- ) {
				file_exists( $file_name . '.' . $i ) && rename( $file_name . '.' . $i, $file_name . '.' . ( $i + 1 ) );
			}
			rename( $file_name, $file_name . '.1' );
			touch( $file_name );
		}
		$sql = sprintf( "select * from nbu_tickets where masterserver='%s' and ended>='%s';", nbu( )->masterserver( ), $ended );
		$rows = database( )->execute_query( $sql );
		debug( $debug_level, timestamp( sprintf( 'Records %s', $rows ) ) );
		$file = new basic_log_file( $file_name );
		$i = 0;
		foreach( database( )->rows( ) as $row ) {
			debug( $debug_level, timestamp( sprintf( 'ID %s', $row[ 'jobid' ] ) ) );
			if ( filter( $ini[ 'NBU2SM9_FILTER_JOBTYPES' ], $row[ 'jobtype' ] ) ) continue;
			if ( filter( $ini[ 'NBU2SM9_FILTER_POLICIES' ], $row[ 'policy' ] ) ) continue;
			if ( filter( $ini[ 'NBU2SM9_FILTER_POLICYTYPES' ], $row[ 'policytype' ] ) ) continue;
			if ( filter( $ini[ 'NBU2SM9_FILTER_STATUSES' ], $row[ 'status' ] ) ) continue;
			if ( $row[ 'ended' ] == $ended and $row[ 'jobid' ]<= $jobid ) continue;
			$line = $ini[ 'NBU2SM9_LINE' ];
			$mtext = $ini[ 'NBU2SM9_MESSAGETEXT' ];
			if ( $ini[ 'NBU2SM9_FILE' ] == 'nbmon.log' ) {
				$line = str_replace( '<@.MGrp>', 'Backup', $line );
				$line = str_replace( '<@.EType>', 'NBU', $line );
			}
			foreach( $row as $key=>$value ) {
				if ( is_numeric( $key ) ) continue;
				$line = str_replace( sprintf( $keymask, strtoupper( $key ) ), $value, $line );
				$mtext = str_replace( sprintf( $keymask, strtoupper( $key ) ), $value, $mtext );
			}
			$line = str_replace( sprintf( $keymask, 'MESSAGETEXT' ), $mtext, $line );
			$file->write( $line );
			debug( $debug_level, timestamp( sprintf( 'Ticket for ID %s created', $jobid ) ) );
			$i++;
		}
#		file_put_contents( $lffile_name, json_encode( array( 'jobid' => $row[ 'jobid' ], 'ended' => $row[ 'ended' ] ) ) );
		logfile( display( 'NBU2SM9 tickets:' . $i ) );
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

		$sql = sprintf( "select * from nbu_esl where masterserver='%s';", nbu( )->masterserver( ) );
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
		
		$sql = sprintf( "select * from nbu_esl_client where masterserver='%s';", nbu( )->masterserver( ) );
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
	debug( 100, timestamp( sprintf( 'READ FILES HOURS %s', $interval ) ) );
	try {	
		$types = '0,13,40';
		$sql = 'SELECT DISTINCT id.backupid FROM ( ';
		$sql .= 'SELECT j.masterserver,j.backupid,j.started FROM bpdbjobs_report j ';
		$sql .= sprintf( "WHERE j.masterserver='%s' AND j.policytype IN (%s) AND j.jobtype IN (0,6,22,28) AND j.state=3 AND j.backupid IS NOT NULL ", 
			nbu( )->masterserver( ), $types );
		$sql .= 'AND j.jobid<>j.parentjob ';
		$sql .= 'AND j.status IN (0,1) ';
		$sql .= sprintf( 'AND j.started>unix_timestamp(NOW()-INTERVAL %s HOUR) ', $interval );
		$sql .= ') id ';
		$sql .= 'LEFT JOIN bpflist_backupid f ON (f.masterserver=id.masterserver AND f.backupid=id.backupid) ';
		$sql .= 'WHERE f.backupid IS NULL ';
		$sql .= 'ORDER BY id.started;';
		logfile( display( 'Backup ID`s:' . database( )->execute_query( $sql ) ) );
		foreach( database( )->rows( ) as $row ) {
//			bpflist_backupid( $row[ 'backupid' ] )->execute( $threads );
			try { handler( bpflist_backupid( $row[ 'backupid' ] )->execute( ) ); } catch ( exception $e ) { exception_handler( $e ); }
		}
//		$threads->execute( );
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function read_all_images( ) {
	global $threads;
	debug( 100, timestamp( 'READ ALL IMAGES' ) );
	try {	
		$sql = 'SELECT DISTINCT c.name FROM bppllist_clients c ';
		$sql .= 'LEFT JOIN nbu_policy_tower_customer ptc ON (ptc.masterserver=c.masterserver AND ptc.policy=c.policyname) ';
		$sql .= sprintf( "WHERE c.masterserver='%s' ", nbu( )->masterserver( ) );
		$sql .= 'AND c.obsoleted IS NULL ';
		$sql .= 'ORDER BY c.NAME;';
		logfile( display( 'Clients:' . database( )->execute_query( $sql ) ) );
		foreach( database( )->rows( ) as $row ) {
//			bpimmedia_client( $row[ 'name' ] )->execute( $threads );
			try { handler( bpimmedia_client( $row[ 'name' ] )->execute( ) ); } catch ( exception $e ) { exception_handler( $e ); }
		}
//		$threads->execute( );
	} catch ( exception $e ) { exception_handler( $e ); }
	return true;
}

function due( $optitem, $iniitem = '' ) {
	global $opt, $ini, $time;
	$match = isset( $ini[ $iniitem ] ) ? preg_match( '/' . $ini[ $iniitem ] . '/', $time ) : false;
	$result = empty( $opt ) ? $match : isset( $opt[ $optitem ] );
	return $result;
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
$opt = array( );
for ( $i = 1; $i < count( $argv ); $i++ ) {
	if ( preg_match( '/^[\/|-]+([^=]+)=?(.*)/', $argv[ $i ], $match ) ) {
        $opt[ strtoupper( $match[ 1 ] ) ] = $match[ 2 ];
    }
}
if ( isset( $opt[ '?' ] ) or isset( $opt[ 'HELP' ] ) ) die( help( ) );
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
	if ( isset( $opt[ 'TIME' ] ) ) { $time = $opt[ 'TIME' ]; unset( $opt[ 'TIME' ] ); }
	empty( $time ) && $time = date( 'H:i' );
	if ( isset( $opt[ 'HOURS' ] ) ) { $hours = $opt[ 'HOURS' ]; unset( $opt[ 'HOURS' ] ); }
	if ( empty( $hours ) ) switch( $time ) {
		case '11:45': $hours = 7; break;
		case '07:45': $hours = 3; break;
		default : $hours = 1; break;
	}
	if ( isset( $opt[ 'DAYS' ] ) ) { $days = $opt[ 'DAYS' ]; unset( $opt[ 'DAYS' ] ); }
	if ( empty( $days ) ) switch( $time ) {
		case '11:15': $days = 3; break;
		case '07:15': $days = 2; break;
		default : $days = 1; break;
	}
	debug( 100, timestamp( sprintf( 'START TIME %s', $time ) ) );
	update( );
	database( new mysqli_database( $ini[ 'DB_HOST' ], $ini[ 'DB_USER' ], $ini[ 'DB_PWD' ], $ini[ 'DB_NAME' ] ) );
	$threads = new multi_thread( $ini[ 'THREADS' ] );
	$threads->root( os( )->path( 'tmp' ) );
	$threads->on_finish_callback( 'on_finish_callback' );
	nbu( )->home( $ini[ 'NBU_BIN_HOME' ] );
	nbu( )->tmp( os( )->path( 'tmp' ) );
	handler( bpdbjobs_summary( )->execute( ) );
	if ( $lock->lock( true ) ) {
		empty( $opt ) || logfile( display( 'Executing ' . implode( ',', array_keys( $opt ) ) ) );
		try { 
			if ( due( 'POLICIES', 'NBUPOLICIES_TIME' ) ) bppllist_policies( )->execute( $threads );
			if ( due( 'CLIENTS', 'NBUCLIENTS_TIME' ) ) bpplclients( )->execute( $threads );
			if ( due( 'JOBS', 'NBUJOBS_TIME' ) ) bpdbjobs_report( $days )->execute( $threads );
			if ( due( 'FILES', 'NBUFILES_TIME' ) ) read_files( $hours );
			if ( due( 'ALLIMAGES' ) ) read_all_images( );
			if ( due( 'IMAGES', 'NBUIMAGES_TIME' ) ) bpimmedia( $days )->execute( $threads );
#			if ( due( 'IMAGES', 'NBUIMAGES_TIME' ) ) bpimagelist_hoursago( $hours )->execute( $threads );
			if ( due( 'SLPS', 'NBUSLP_TIME' ) ) nbstl( )->execute( $threads );
			$threads->execute( );
			if ( due( 'VAULTS', 'NBUVAULT_TIME' ) ) try { handler( vault_xml( os( )->path( array ( $ini[ 'NBU_DATA_HOME' ], 'db', 'vault' ) ) )->execute( ) ); } catch ( exception $e ) { exception_handler( $e ); }
			if ( due( 'RETLEVELS', 'NBURETLEVEL_TIME' ) ) try { handler( bpretlevel( )->execute( ) ); } catch ( exception $e ) { exception_handler( $e ); }
			if ( due( 'ESL', 'NBU2ESL_TIME' ) ) nbu2esl( );
			if ( due( 'SM9', 'NBU2SM9_TIME' ) ) nbu2sm9( );
		} catch ( exception $e ) { exception_handler( $e ); }
		$lock->lock( false );
	} else {
		logfile( display( 'Another instance in progress.' ) );
	}
	$threads->execute( );
} catch ( exception $e ) { exception_handler( $e ); }
display( '------' );
display( sprintf( 'Memory used: %sMb',round( os( )->memory_peak( ) /1000000, 1 ) ) );
display( sprintf( 'Duration: %sms', os( )->duration( ) ) );
debug( 100, timestamp( 'STOP' ) );
