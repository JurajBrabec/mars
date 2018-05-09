<?php

/*
 * MARS 4.0 PHP CODE
* build 4.0.0.0 @ 2016-09-11 00:00
* * rewritten from scratch
*/

require_once __DIR__ . '/inc/os.php';
require_once __DIR__ . '/inc/database.php';
require_once __DIR__ . '/inc/nbu_commands.php';

#-----------------------------------

function on_finish_callback( $threads, $thread ) {
	try {
		$name = $threads->put( $thread );
		handler( nbu( )->get( $name, $threads->get( $name ) ) );
	} catch ( exception $e ) {
		logfile( timestamp( display( $e->getMessage( ) ) ) );
	}
}

function handler( $object ) {
	if ( !is_object( $object ) ) return false;
	logfile( display( 'Report: ' . get_class( $object ) ) );
	$sql = $object->SQL( get_class( $object ) );
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
}

function update( ) {
	global $ini;
	$url = sprintf( 'http://%s/nbu/client/update.zip', $ini[ 'DB_HOST' ] );
	$root = dirname( __FILE__ );
	$tmp = $root . DIRECTORY_SEPARATOR . 'tmp';
	$build = $root . DIRECTORY_SEPARATOR . 'build';
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
			$update = $tmp . DIRECTORY_SEPARATOR . $etag . '.zip';
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
}

function nbu2sm9( ) {
	global $ini;
	$ini[ 'NBU2SM9_FILE' ] = 'nbu_mars_sm9.txt';
	$ini[ 'NBU2SM9_PATH' ] = 'tmp';
	$ini[ 'NBU2SM9_DELIMITER' ] = ';;';
	if ( !is_dir( $ini[ 'NBU2SM9_PATH' ] ) ) mkdir( $ini[ 'NBU2SM9_PATH' ], 0777, true );
	$file_name = $ini[ 'NBU2SM9_PATH' ] . DIRECTORY_SEPARATOR . $ini[ 'NBU2SM9_FILE' ];
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
		if ( !file_exists( $file_name ) ) $file->write( implode( $ini[ 'NBU2SM9_DELIMITER' ], array_keys( $NBU2SM9_TXT_FIELDS ) ) );
		$file->write( implode( $ini[ 'NBU2SM9_DELIMITER' ], $NBU2SM9_TXT_FIELDS ) );
	}
}

function nbu2esl( ) {
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
#		,'Ticket Postpone Time'	=> ''
#		,'Backup Reportable'		=> '1'
	);
	$NBU2ESL_CLIENT_TXT_FIELDS = array( 
		'System Name'			=> ''
		,'Backup Method'		=> 'NetBackup'
		,'Backup Name'			=> ''
		,'Client System Name'	=> ''
	);
	$LINE1 = '#Automatic upload for backup information to ESL';
	$LINE2 = '#Generated by MARS 4.0 @ ' . date( 'd.m.Y H:i' );

	if ( !is_dir( $ini[ 'NBU2ESL_PATH' ] ) ) mkdir( $ini[ 'NBU2ESL_PATH' ], 0777, true );

	$sql = "select * from nbu_esl;";
	logfile( display( 'NBU2ESL policies:' . database( )->execute_query( $sql ) ) );
	$file_name = $ini[ 'NBU2ESL_PATH' ] . DIRECTORY_SEPARATOR . $NBU2ESL_TXT;
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
	$file_name = $ini[ 'NBU2ESL_PATH' ] . DIRECTORY_SEPARATOR . $NBU2ESL_CLIENT_TXT;
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
}

display( '------' );
try {
	if ( !os( )->php( '5.3' ) ) throw new exception( sprintf( os::PHP_UNSUPPORTED, os::php( ) ) );
	$ini = array_change_key_case( parse_ini_file( __DIR__ . '/config.ini' ), CASE_UPPER );
	IF ( empty( $ini[ 'NBU2SM9_PERIODICITY' ] ) ) $ini[ 'NBU2SM9_PERIODICITY' ] = 5;
	date_default_timezone_set( $ini[ 'TIME_ZONE' ] );
#	$time = time( ) / 3600 % 24 * 60 + time( ) / 60 % 60;
	$time = intval( date( 'H' ) ) * 60 + intval( date( 'i' ) );
	$lock = new lock_file( os( )->path( 'mars4.lock' ) );
	logfile( new log_file( os( )->path( array( 'log', 'mars4.log' ) ) ) );
	debug( new debug_log_file( os( )->path( array( 'log', 'mars4.debug.log' ) ) ) );
	debug( )->enabled( $ini[ 'DEBUG' ] );
	debug( 100, timestamp( 'START' ) );
	database( new mysqli_database( $ini[ 'DB_HOST' ], $ini[ 'DB_USER' ], $ini[ 'DB_PWD' ], $ini[ 'DB_NAME' ] ) );
	$threads = new multi_thread( $ini[ 'THREADS' ] );
	$threads->root( os( )->path( 'tmp' ) );
	$threads->on_finish_callback( 'on_finish_callback' );
	nbu( )->home( $ini[ 'VERITAS_HOME' ] );
	nbu( )->tmp( os( )->path( 'tmp' ) );
	if ( $lock->lock( true ) ) {
	    switch( date( 'H:i' ) ) {
	        case '00:00': $days = 32; break;
	        case '12:00': $days = 16; break;
	        case '06:00':
	        case '18:00': $days = 8; break;
	        default : switch ( date( 'i' ) ){
	            case '00' : $days = 4; break;
	            case '30' : $days = 2; break;
	            case '15' :
	            case '45' : $days = 1; break;
	            default : $days = 0; break;
	        }
	    }
		update( );
		handler( bpdbjobs_summary( )->execute( ) );
		if ( $time % $ini[ 'NBURETLEVEL_PERIODICITY' ] == 0 ) handler( bpretlevel( )->execute( ) );
		if ( $time % $ini[ 'NBUVAULT_PERIODICITY' ] == 0 ) handler( vault_xml( $ini[ 'VAULT_HOME' ] )->execute( ) );
		if ( $time % $ini[ 'NBUJOBS_PERIODICITY' ] == 0 ) bpdbjobs_report( $days )->execute( $threads );
		if ( $time % $ini[ 'NBUPOLICIES_PERIODICITY' ] == 0 ) bppllist_policies( )->execute( $threads );
		$threads->execute( );
		$lock->lock( false );
	}
	if ( $time % $ini[ 'NBU2ESL_PERIODICITY' ] == 0 ) nbu2esl( );
	if ( $time % $ini[ 'NBU2SM9_PERIODICITY' ] == 0 ) nbu2sm9( );
} catch ( exception $e ) {
	logfile( timestamp( display( $e->getMessage( ) ) ) );
}
display( '------' );
display( sprintf( 'Memory used: %sb',os( )->memory( ) ) );
display( sprintf( 'Duration: %sms', os( )->duration( ) ) );
debug( 100, timestamp( 'STOP' ) );
