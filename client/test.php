<?php

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
echo $days;
echo PHP_EOL;
echo date( 'm/d/Y H:i:s', time( ) - ( 60 * 60 * ( 24 * $days + 1 ) ) );
die();
function xml( ) {
    $skip_items = array( 
        'MAP','RETENTION_MAP','RETMAP_ITEM',
        'REPORT','REPORTS_SETTINGS','REPORTS',
        'VAULT_PREFERENCES','ALIASES'
    );
    
    function parse_item( $item, $prefix = '' ) {
        global $skip_items;
        $result = array();
        if ( !in_array( $item->getName(), $skip_items ) ) {
            $string = trim( $item->__toString( ) );
            if ( !empty( $string ) ) $result[ $item->getName() ][ ] = $string;
            echo $prefix . $item->getname() . '{';
            echo $string;
            foreach( $item->attributes() as $key=>$value ) {
                $value = trim( $value->__toString( ) );
                $result[ $item->getName() ][ $key ] = $value;
                echo $key . ':"' . $value, '";';
            }
            echo '}' . PHP_EOL;
        }
        foreach( $item->children() as $child ) $result[ ] = parse_item( $child, $prefix . '-' );
        return $result;
    }
    
    $vault = parse_item( new SimpleXMLElement( file_get_contents( 'm:\\Veritas\\NetBackup\\db\\vault\vault.xml' ) ) );
#   print_r( $vault );
}

require_once dirname( __FILE__ ) . '/inc/os.php';
require_once dirname( __FILE__ ) . '/inc/database.php';

#-----------------------------------

function condition_callback( $threads ) {
	$result = $threads->duration( ) < 45;
	if ( !$result ) display( 'Break condition encountered.' );
	return $result;
}
function on_assign_callback( $threads, $thread ) {
	$name = $thread->name( );
	$params = $thread->params( );
}

function on_finish_callback( $threads, $thread ) {
	logfile( timestamp( display( 'Result: ' ) . display( $thread->name( ) . print_r( $thread->result( ), true ) ) ) );
	$name = $threads->put( $thread );
	$t = $threads->get( $name );
	display( 'Result: ' ) . display( $t->lines( ) );
	display( sprintf( 'Fields (%s): %s', count( $t->fields( ) ), print_r( $t->fields( ), true ) ) );
	display( sprintf( 'Rows (%s): %s', count( $t->rows( ) ), print_r( $t->rows( ), true ) ) );
	}

	function single_thread_test( ) {
		$name = 'TASK0';
#		$command = 'ping -n 5 localhost';
		$command = '"C:\Windows\System32\ping.exe" "localhost"';
		$items = array( );
		$thread = new thread( $command, $name );
		$task = $thread->finish( );
		logfile( timestamp( display( 'Result: ' ) . display( print_r( $task, true ) ) ) );
	}
	
	function multi_thread_test( ) {
		$name = 'TASK0';
		$command = 'ping -n 5 localhost';
		$items = array( );
		$threads = new multi_thread( 5 );
		$threads->root( $os->path( 'tmp' ) );
		display( $threads->root( ) );
		$threads->condition_callback( 'condition_callback' );
		$threads->on_assign_callback( 'on_assign_callback' );
		$threads->on_finish_callback( 'on_finish_callback' );
		$threads->queue( new task ( 'ping -n 9 localhost', 'TASK1' ) );
		$threads->queue( new task( 'ping -n 4 localhost', 'TASK2' ) );
		$threads->queue( new task ('ping  localhost', 'TASK3' ) );
		$threads->queue( new task( 'ping -n 3 localhost' ) );
	
		if ( !( $task = $threads->get( $name ) ) ) {
			$threads->queue( new task( $command, $name, $items ) );
			$threads->execute( );
			$task = $threads->get( $name );
		}
		logfile( timestamp( display( 'Result: ' ) . display( print_r( $task, true ) ) ) );
	}
	
function omni_on_finish_callback( $threads, $thread ) {
	logfile( timestamp( display( 'Result: ' ) . display( $thread->name( ) . print_r( $thread->result( ), true ) ) ) );
	$name = $threads->put( $thread );
	omni_process( omni( )->get( $name, $threads->get( $name ) ) );
#	$name = $thread->name( );
#	$params = $thread->params( );
#	omni_process( omni( )->get( $name, $thread ) );
	if ( isset( $params[ 'ITEMS' ] ) ) {
		$items = $params[ 'ITEMS' ];
#		execute_actions( $this, $items[ 'NAME' ], $items[ 'DATA' ] );
	}
}

function omni_process( $t ) {
	if ( !is_object( $t ) ) return FALSE;
	switch ( get_class( $t ) ) {
		case 'ps': display( 'Processes: ' . print_r( $t->processes( ), true) ); break;
		case 'omnidbutil_show_cell_name': display( 'Cell Server: ' . $t->cellserver( ) ); break;
		case 'omnisv_version': display( 'Version: ' . $t->version( ) );
		display( 'Build: ' . $t->build( ) );
		display( 'Timestamp: ' . $t->timestamp( ) );
		break;
		case 'omnisv_status':display( 'Services: ' . print_r( $t->services( ), true ) );
		display( 'Status: ' . $t->status( ) );
		break;
		case 'omnistat':
		case 'omnistat_detail':
		case 'omnistat_previous':
		case 'omnistat_previous_last':
			display( 'Sessions: ' . print_r( $t->sessions( ), true ) );
			break;
		case 'omnistat_session':
		case 'omnistat_session_detail':
			display( 'Devices: ' . print_r( $t->devices( ), true ) );
			display( 'Objects: ' . print_r( $t->objects( ), true ) );
			break;
		case 'omnistat_session_devices':
		case 'omnistat_session_detail_devices':
		case 'omnirpt_session_devices':
			display( 'Devices: ' . print_r( $t->devices( ), true ) );
			break;
		case 'omnistat_session_objects':
		case 'omnistat_session_detail_objects':
		case 'omnidb_session':
		case 'omnidb_session_detail':
		case 'omnirpt_single_session_failed_objects':
		case 'omnirpt_session_objects':
			display( 'Objects: ' . print_r( $t->objects( ), true ) );
			break;
		case 'omnidb_rpt':
		case 'omnidb_rpt_detail':
		case 'omnirpt_single_session_session':
			display( 'Session: ' . print_r( $t->session( ), true ) );
			break;
		case 'omnidb_session_media':
		case 'omnidb_session_media_detail':
		case 'omnirpt_session_media':
			display( 'Media: ' . print_r( $t->media( ), true ) );
			break;
		case 'omnidb_session_report':
		case 'omnirpt_single_session_errors':
			display( 'Errors: ' . print_r( $t->errors( ), true ) );
			break;
		case 'omnirpt_single_session':
			display( 'Session: ' . print_r( $t->session( ), true ) );
			display( 'Failed objects: ' . print_r( $t->objects( ), true ) );
			display( 'Errors: ' . print_r( $t->errors( ), true ) );
			break;
		default:
			display( 'Result: ' ) . display( $t->lines( ) );
			display( sprintf( 'Fields (%s): %s', count( $t->fields( ) ), print_r( $t->fields( ), true ) ) );
			display( sprintf( 'Rows (%s): %s', count( $t->rows( ) ), print_r( $t->rows( ), true ) ) );
	}
	display( 'SQL: ' . $t->SQL( get_class( $t ) ) );
}

function omni_test( $multi_thread = 0 ) {
#	$t = os( )->processes( );
	omni( )->home( 'M:\\Omniback' );
	omni( )->tmp( os( )->path( 'tmp' ) );
	omni( )->cellserver( 'dp21.ais.trce.hp.com' );
#	$t = omnidbutil_show_cell_name( );
#	$t = omnisv_version( );
#	$t = omnisv_status( );
$t = omnistat( );
#	$t = omnistat_detail( );
#	$t = omnistat_previous( );
#	$t = omnistat_previous_last( 3 );
#	$t = omnistat_session( '2016/02/04-1014' );
#	$t = omnistat_session_detail( '2016/02/04-1014' );
#	$t = omnidb_rpt( '2016/02/02-1' );
#	$t = omnidb_rpt_detail( '2016/02/02-1' );
#	$t = omnidb_session( '2016/02/19-5' );
#	$t = omnidb_session_detail( '2016/02/19-5' );
#	$t = omnidb_session_media( '2016/02/19-5' );
#	$t = omnidb_session_media_detail( '2016/02/19-5' );
#	$t = omnidb_session_report( '2016/02/19-5' );
#	$t = omnirpt_single_session( '2016/02/19-13' );
#	$t = omnirpt_session_devices( '2016/02/19-13' );
#	$t = omnirpt_session_objects( '2016/02/19-13' );
#	$t = omnirpt_session_media( '2016/02/19-13' );
	
	if ( $multi_thread == 0 ) {
		$t->execute( );
		omni_process( $t );
	} else {
		$items = array( );
		$threads = new multi_thread( 5 );
		$threads->root( $os->path( 'tmp' ) );
		$threads->condition_callback( 'condition_callback' );
		$threads->on_assign_callback( 'on_assign_callback' );
		$threads->on_finish_callback( 'omni_on_finish_callback' );
		$t->execute( $threads );
		$threads->execute( );
	}
}

function nbu_on_finish_callback( $threads, $thread ) {
	logfile( timestamp( display( 'Result: ' . $thread->name( ) ) . display( print_r( $thread->result( ), true ) ) ) );
	$name = $threads->put( $thread );
	nbu_process( nbu( )->get( $name, $threads->get( $name ) ) );
}

function nbu_process( $t ) {
	if ( !is_object( $t ) ) return FALSE;
	switch ( get_class( $t ) ) {
		case 'bpdbjobs_summary': display( 'Summary: ' . print_r( $t->summary( ), true) ); return; break;
		case 'bpdbjobs_report': display( 'Jobs: ' . count( $t->jobs( ) ) ); break;
		case 'bppllist_policies': 
			display( 'Policies: '. count( $t->policies( ) ) ); 
			display( 'Clients: ' . count( $t->clients( ) ) );
			display( 'Schedules: ' . count( $t->schedules( ) ) );
			break;
		case 'vault_xml':
			display( 'Vault rows: ' . count( $t->rows( ) ) );
			break;
		default:
			display( 'Result: ' ) . display( $t->lines( ) );
			display( sprintf( 'Fields (%s): %s', count( $t->fields( ) ), print_r( $t->fields( ), true ) ) );
			display( sprintf( 'Rows (%s): %s', count( $t->rows( ) ), print_r( $t->rows( ), true ) ) );
	}
	$sql = $t->SQL( get_class( $t ) );
	is_array( $sql ) || $sql = array( $sql );
	foreach( $sql as $s ) {
		display( 'SQL: ' . $s );
#		display( 'SQL result:' . database( )->execute_query( $s ) );
#		display( 'SQL insert ID:' . database( )->insert_id( ) );
#		display( 'SQL rows:' . database( )->row_count( ) );
#		display( 'SQL info:' . database( )->query_info( ) );
#		display( 'SQL error:' . database( )->error( ) );
#		display( 'SQL message:' . database( )->message( ) );
#		display( 'SQL duration:' . database( )->duration( ) );
	}
}

function nbu_test( $multi_thread = 0 ) {
	nbu( )->home( 'M:\\Veritas' );
	nbu( )->tmp( os( )->path( 'tmp' ) );
#	nbu( )->masterserver( 'nlr-nbmastc1.res.hpe.com' );
#	nbu_process( bpdbjobs_summary( )->execute( ) );
#	$t = bpdbjobs_report( );
#	$t = bppllist_policies( );
#	$t = bpretlevel( );
    $t = vault_xml( 'm:\\Veritas\\NetBackup\\db\\vault' );
    if ( $multi_thread == 0 ) {
		$t->execute( );
		nbu_process( $t );
	} else {
		$items = array( );
		$threads = new multi_thread( 5 );
		$threads->root( os( )->path( 'tmp' ) );
		$threads->condition_callback( 'condition_callback' );
		$threads->on_assign_callback( 'on_assign_callback' );
		$threads->on_finish_callback( 'nbu_on_finish_callback' );
		$t->execute( $threads );
		$threads->execute( );
	}
}

try {
	if ( !os( )->php( '5.5' ) ) throw new exception( sprintf( os::PHP_UNSUPPORTED, os::php( ) ) );
#	database( new mysqli_database( 'localhost', 'script', 'm@r5', 'mars40' ) );
	$lock = new lock_file( os( )->path( 'test.lock' ) );
	logfile( new log_file( os( )->path( 'test.log' ) ) );
	debug( new debug_log_file( os( )->path( 'debug.log' ) ) );
	debug( )->enabled( true );
	debug( 100, timestamp( 'START' ) );
	logfile( timestamp( display( os( )->name( ) . '-' . os( )->root( ) ) ) );

	if ( $lock->lock( true ) ) {
#		single_thread_test( );
#		multi_thread_test( );
#		require_once dirname( __FILE__ ) . '/inc/omni_commands.php';
#		omni_test( );
		require_once dirname( __FILE__ ) . '/inc/nbu_commands.php';
		nbu_test( );
		$lock->lock( false );
	}
} catch ( exception $e ) {
	display( $e->getmessage( ) );
}

display( '------' );
display( sprintf( 'Memory used: %sb',os( )->memory( ) ) );
display( sprintf( 'Duration: %sms', os( )->duration( ) ) );
debug( 100, timestamp( 'STOP' ) );
