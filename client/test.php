<?php
require_once dirname( __FILE__ ) . '/inc/os.php';

class streamText {
	const MAXMEMORY		= 1024 * 1024;
	const ERROR_FOPEN	= 'Unable to open stream.';
	const BUFFERSIZE	= 1024;
	
	private $stream		= NULL;

	public function stream( $value = NULL ) { return _var( $this->stream, func_get_args( ) ); }
	
	public function __construct( $source = NULL ) {
		$this->loadFrom( $source );
		return TRUE;
	}

	public function clearStream( ) {
		$this->closeStream( );
		$stream = fopen( sprintf( 'php://temp/maxmemory:%s', static::MAXMEMORY ), 'w' );
		if ( !is_resource( $stream ) ) throw new Exception( static::ERROR_FOPEN );
		$this->stream( $stream );
		return TRUE;
	}

	public function loadFrom( $source ) {
		$this->clearStream( );
		$result = $this->add( $source );
		rewind( $this->stream( ) );
		return $result;
	}

	public function add( $source ) {
		$result =FALSE;
		is_array( $source ) && $result = fputs( $this->stream( ), explode( PHP_EOL, $source ) );
		is_resource( $source ) && $result = fputs( $this->stream( ), stream_get_contents( $source ) );
		if ( is_string( $source ) ) {
			if ( file_exists( $source ) ) {
				$result = fputs( $this->stream( ), file_get_contents( $source ) );
			} else {
				$result = fputs( $this->stream( ), $source );
			}
		}
		return $result;
	}

	public function asText( ) {
		rewind( $this->stream( ) );
		return stream_get_contents( $this->stream( ) );
	}
	
	public function asFormattedText( $pattern = '%s' ) {
		$result = '';
		rewind( $this->stream( ) );
		while ( ( $buffer = fgets( $this->stream( ) ) ) !== false ) {
			$result .= sprintf( $pattern, trim( $buffer ) ) . PHP_EOL;
		}
		return $result;
	}
	
	public function saveTo( $filename ) {
		rewind( $this->stream( ) );
		return file_put_contents( $filename, stream_get_contents( $this->stream( ) ) );
	}

	public function closeStream( ) {
		is_resource( $this->stream( ) ) && fclose( $this->stream( ) );
		$this->stream = NULL;
		return TRUE;
	}

	public function __destruct( ) {
		$this->closeStream( );
		return TRUE;
	}
}

class structuredText {
	const TEXT			= '\S+';
	const NUMBER		= '\d+';
	const SEPARATOR		= "\n";
	const DELIMITER		= "\n";
	const ERROR_PARSE	= 'Error parsing item #%d:"%s"';

	private $source		= NULL;
	private $fields		= array( );
	private $pattern	= NULL;
	private $result		= NULL;

	public function source( $value = NULL ) { return _var( $this->source, func_get_args( ) ); }
	public function fields( $field = NULL, $value = NULL ) { return _arr( $this->fields, func_get_args( ) ); }
	public function pattern( $value = NULL ) { return _var( $this->pattern, func_get_args( ) ); }
	public function result( $value = NULL ) { return _var( $this->result, func_get_args( ) ); }
	
	public function __construct( $source = NULL ) {
		$this->source( new streamText( $source ) );
		$this->result( new streamText( ) );
		return TRUE;
	}

	public function prepareFields( ) {
		$fields = array( );
		$fields[ 'line' ] = array( '.*','%s' );
		return $fields;
	}

	public function preparePattern( ) {
		$pattern = array( );
		foreach ( $this->fields( ) as $name => $value ) {
			list( $type, $text ) = $value;
			$pattern[ ] = sprintf( '(?>%s)', sprintf( $text, sprintf( '(?<%s>%s)', $name, $type ) ) );
		}
		return implode( static::DELIMITER, $pattern );
	}
	
	public function parseSource( ) {
		$this->fields( $this->prepareFields( ) );
		$this->pattern( $this->preparePattern( ) );
		$this->result( )->clearStream( );
		$i = 0;
		while ( !feof( $this->source( )->stream( ) ) ) {
			try {
				$item = stream_get_line( $this->source( )->stream( ), streamText::BUFFERSIZE, static::SEPARATOR );
				$result = $this->parseItem( $item );
				if ( !$result  or count( $result ) == 0 ) throw new Exception( sprintf( static::ERROR_PARSE, $i + 1, $item ) );
				fputcsv( $this->result( )->stream( ), $result );
				$i ++;
			} catch (Exception $e) {
				echo 'Exception: ' .  $e->getMessage( ) . PHP_EOL;
			}
		}
		return $i;
	}

	public function parseItem( $item ) {
		$result = FALSE;
		if ( preg_match( sprintf( '/%s/m', $this->pattern( ) ), $item, $match ) ) {
			$result = array( );
			foreach ( $match as $key => $value ) {
				if ( !empty( $this->fields( $key ) ) ) {
					$result[ $key ] = $this->fields( $key )[ 0 ] == static::NUMBER ? trim( $value ) : sprintf( "'%s'", trim( $value ) );
				}
			}
		}
		return $result;
	}

	public function __destruct( ) {
		$this->source( )->closeStream( );
		$this->result( )->closeStream( );
		return TRUE;
	}
}

class structuredCmd extends structuredText {
	const PATH					= '';
	const BIN					= '';
	const ARGUMENTS				= '%s';
	private $path				= '';
	private $bin				= '';
	private $arguments			= NULL;
	private $duration			= 0;
	private $status				= array( );

	public function path( $value = NULL ) { return _var( $this->path, func_get_args( ) ); }
	public function bin( $value = NULL ) { return _var( $this->bin, func_get_args( ) ); }
	public function arguments( $value = NULL ) { return _var( $this->arguments, func_get_args( ) ); }
	public function duration( $value = NULL ) { return _var( $this->duration, func_get_args( ) ); }
	public function status( $field = NULL, $value = NULL ) { return _arr( $this->status, func_get_args( ) ); }

	public function __construct( $arguments = NULL ) {
		parent::__construct( );
		$this->path( static::PATH );
		$this->bin( static::BIN );
		$this->arguments( $arguments );
	}

	public function cmdline( ) {
		$cmd = escapeshellarg( $this->path( ) . ( empty( $this->path( ) ) ? '' : DIRECTORY_SEPARATOR ) . $this->bin( ) );
		$arguments = sprintf( ' ' . static::ARGUMENTS, is_array( $this->arguments( ) ) ? implode( ' ', $this->arguments( ) ) : $this->arguments( ) );
		return trim( $cmd . $arguments );
	}
	
	public function execute( ) {
		$result = FALSE;
		$start_time = microtime( TRUE );
		$descriptorspec = array(
			0 => array( 'pipe', 'r' ),
			1 => array( 'pipe', 'w' ),
			2 => array( 'pipe', 'w' )
		);
		$proc = proc_open( $this->cmdline( ), $descriptorspec, $pipes );
		if ( is_resource( $proc ) ) {
			fclose( $pipes[ 0 ] );
			$this->source( )->add( $pipes[ 1 ] );
			fclose( $pipes[ 1 ] );
			$this->source( )->add( $pipes[ 2 ] );
			fclose( $pipes[ 2 ] );
			$this->status( proc_get_status( $proc ) );
			$result = proc_close( $proc );
			rewind( $this->source( )->stream( ) );
		}
		$end_time = microtime( TRUE );
		$this->duration( round( $end_time - $start_time, 2 ) );
		return $result;
	}
}

class nbuCmd extends structuredCmd {
	const HOME				= '';
	private $home			= '';
	private $masterserver	= '';

	public function home( $value = NULL ) { return _var( $this->home, func_get_args( ) ); }
	public function masterserver( $value = NULL ) { return _var( $this->masterserver, func_get_args( ) ); }

	public function __construct( $arguments = NULL ) {
		parent::__construct( $arguments );
		$this->home( static::HOME );
		if ( is_object( nbu( ) ) ) {
			is_null( nbu( )->home( ) ) || $this->home( nbu( )->home( ) );
			is_null( nbu( )->masterserver( ) ) || $this->masterserver( nbu( )->masterserver( ) );
		}
		$this->path( $this->home( ) . DIRECTORY_SEPARATOR . $this->path( ) );
	}
	
}

class bpdbjobsCmd extends nbuCmd {
	const PATH			= 'bin\admincmd';
	const BIN			= 'bpdbjobs';
}

class bpdbjobsSummary extends bpdbjobsCmd {
	const ARGUMENTS		= '-summary -l';
	const SEPARATOR 	= "\n\n";
	const DELIMITER 	= '\s+';

	public function prepareFields( ) {
		$fields = array( );
		$fields[ 'masterserver' ]	= array( static::TEXT, 'Summary of jobs on %s' );
		$fields[ 'queued' ]			= array( static::NUMBER, 'Queued: +%s' );
		$fields[ 'wtr' ]			= array( static::NUMBER, 'Waiting-to-Retry: +%s' );
		$fields[ 'active' ]			= array( static::NUMBER, 'Active: +%s' );
		$fields[ 'successful' ]		= array( static::NUMBER, 'Successful: +%s' );
		$fields[ 'partial' ]		= array( static::NUMBER, 'Partially Successful: +%s' );
		$fields[ 'failed' ]			= array( static::NUMBER, 'Failed: +%s' );
		$fields[ 'incomplete' ]		= array( static::NUMBER, 'Incomplete: +%s' );
		$fields[ 'suspended' ]		= array( static::NUMBER, 'Suspended: +%s' );
		$fields[ 'total' ]			= array( static::NUMBER, 'Total: +%s' );
		return $fields;
	}
}

class bpdbjobsReport extends bpdbjobsCmd {
#	const ARGUMENTS		= '-report -most_columns -t %s';
	const ARGUMENTS		= '-report -most_columns';
	const SEPARATOR 	= "\n";
	const DELIMITER 	= ',';

	public function prepareFields( ) {
		$fields = array( );
		$fields[ 'jobid' ]				= array( static::NUMBER, '%s' );
		$fields[ 'jobtype' ]			= array( static::NUMBER, '%s' );
		$fields[ 'state' ]				= array( static::NUMBER, '%s' );
		$fields[ 'status' ]				= array( static::NUMBER, '%s' );
		$fields[ 'policy' ]				= array( static::TEXT, '%s' );
		$fields[ 'schedule' ]			= array( static::TEXT, '%s' );
		$fields[ 'client' ]				= array( static::TEXT, '%s' );
		$fields[ 'server' ]				= array( static::TEXT, '%s' );
		$fields[ 'started' ]			= array( static::NUMBER, '%s' );
		$fields[ 'elapsed' ]			= array( static::NUMBER, '%s' );
		$fields[ 'ended' ]				= array( static::NUMBER, '%s' );
		$fields[ 'stunit' ]				= array( static::TEXT, '%s' );
		$fields[ 'tries' ]				= array( static::NUMBER, '%s' );
		$fields[ 'operation' ]			= array( static::NUMBER, '%s' );
		$fields[ 'kbytes' ]				= array( static::NUMBER, '%s' );
		$fields[ 'files' ]				= array( static::NUMBER, '%s' );
		$fields[ 'pathlastwritten' ]	= array( static::TEXT, '%s' );
		$fields[ 'percent' ]			= array( static::NUMBER, '%s' );
		$fields[ 'jobpid' ]				= array( static::NUMBER, '%s' );
		$fields[ 'owner' ]				= array( static::TEXT, '%s' );
		$fields[ 'subtype' ]			= array( static::NUMBER, '%s' );
		$fields[ 'policytype' ]			= array( static::NUMBER, '%s' );
		$fields[ 'scheduletype' ]		= array( static::NUMBER, '%s' );
		$fields[ 'priority' ]			= array( static::NUMBER, '%s' );
		$fields[ 'group' ]				= array( static::TEXT, '%s' );
		$fields[ 'masterserver' ]		= array( static::TEXT, '%s' );
		$fields[ 'retentionlevel' ]		= array( static::NUMBER, '%s' );
		$fields[ 'retentionperiod' ]	= array( static::NUMBER, '%s' );
		$fields[ 'compression' ]		= array( static::NUMBER, '%s' );
		$fields[ 'kbytestobewritten' ]	= array( static::NUMBER, '%s' );
		$fields[ 'filestobewritten' ]	= array( static::NUMBER, '%s' );
		$fields[ 'filelistcount' ]		= array( static::NUMBER, '%s' );
		$fields[ 'trycount' ]			= array( static::NUMBER, '%s' );
		$fields[ 'parentjob' ]			= array( static::NUMBER, '%s' );
		$fields[ 'kbpersec' ]			= array( static::NUMBER, '%s' );
		$fields[ 'copy' ]				= array( static::NUMBER, '%s' );
		$fields[ 'robot' ]				= array( static::TEXT, '%s' );
		$fields[ 'vault' ]				= array( static::TEXT, '%s' );
		$fields[ 'profile' ]			= array( static::TEXT, '%s' );
		$fields[ 'session' ]			= array( static::NUMBER, '%s' );
		$fields[ 'ejecttapes' ]			= array( static::NUMBER, '%s' );
		$fields[ 'srcstunit' ]			= array( static::TEXT, '%s' );
		$fields[ 'srcserver' ]			= array( static::TEXT, '%s' );
		$fields[ 'srcmedia' ]			= array( static::TEXT, '%s' );
		$fields[ 'dstmedia' ]			= array( static::TEXT, '%s' );
		$fields[ 'stream' ]				= array( static::NUMBER, '%s' );
		$fields[ 'suspendable' ]		= array( static::NUMBER, '%s' );
		$fields[ 'resumable' ]			= array( static::NUMBER, '%s' );
		$fields[ 'restartable' ]		= array( static::NUMBER, '%s' );
		$fields[ 'datamovement' ]		= array( static::NUMBER, '%s' );
		$fields[ 'snapshot' ]			= array( static::NUMBER, '%s' );
		$fields[ 'backupid' ]			= array( static::TEXT, '%s' );
		$fields[ 'killable' ]			= array( static::NUMBER, '%s' );
		$fields[ 'controllinghost' ]	= array( static::TEXT, '%s' );
#		$fields[ 'offhosttype' ]		= array( static::NUMBER, '%s' );
		$fields[ 'ftusage' ]			= array( static::NUMBER, '%s' );
		$fields[ 'queuereason' ]		= array( static::NUMBER, '%s' );
		$fields[ 'reasonstring' ]		= array( static::TEXT, '%s' );
		$fields[ 'dedupratio' ]			= array( static::NUMBER, '%s' );
		$fields[ 'accelerator' ]		= array( static::NUMBER, '%s' );
		$fields[ 'instancedbname' ]		= array( static::TEXT, '%s' );
		$fields[ 'rest1' ]				= array( static::NUMBER, '%s' );
		$fields[ 'rest2' ]				= array( static::NUMBER, '%s' );
		return $fields;
	}
	
	public function parseItem( $item ) {
		$values = str_getcsv( $item, static::DELIMITER );
		$result = array( );
		$i = 0;
		foreach( $this->fields( ) as $key => $field ) {
			$result[ $key ] = $field[ 0 ] == static::NUMBER ? trim( $values[ $i ] ) : sprintf( "'%s'", trim( $values[ $i ] ) );
			$i++;
		}
		return $result;

	}
}

function nbu( ) { global $nbu; return $nbu; }
function bpdbjobsSummary( ) { return new bpdbjobsSummary; }
function bpdbjobsReport( $days = 7 ) { return new bpdbjobsReport( date( 'm/d/Y H:i:s', time( ) - ( 60 * 60 * ( 24 * $days + 1 ) ) ) ); }

$nbu = new nbuCmd( );

date_default_timezone_set( 'Europe/Bratislava' );

nbu( )->home( 'M:\Veritas\NetBackup' );
nbu( )->masterserver( 'test.local' );

#$obj = bpdbjobsSummary( );
$obj = bpdbjobsReport( );
#$obj->source( )->loadFrom( 'm:\stream.txt' );
$obj->execute( );
$obj->parseSource( );
echo $obj->result( )->asFormattedText( 'call test(%s);' );
#echo $obj->result( )->asText( );
$obj->result( )->saveTo( 'm:\result.txt' );
die( );






function memtest() {
	ini_set('display_errors', false);
	error_reporting(-1);
	register_shutdown_function( function( ){
		$error = error_get_last( );
		if( !empty( $error ) ) {
			echo 'Peak: ' . round( memory_get_peak_usage( )/1000000, 1 ) . 'Mb' . PHP_EOL;
			echo array_search($error['type'], get_defined_constants());
			echo ' caught at shutdown.' . PHP_EOL;
			print_r( $error );
		}
	} );
	try {
		ini_set('memory_limit','-1');
		$a = array( );
		$i = 0;
		while ( $i < 170000000 ) {
			$a[ ] = '0123456789';
			if ( $i % 1000 == 0 ) {
				echo $i . ' ' . round( memory_get_usage( )/1000000, 1 ) . 'Mb' . PHP_EOL;
			}
			$i++;
		}
		echo $i . ' ' . round( memory_get_usage( )/1000000, 1 ) . 'Mb' . PHP_EOL;
		unset( $a );
	} catch ( exception $e ) {
		echo $e->getmessage( ) . PHP_EOL;
	}
	echo 'Peak: ' . round( memory_get_peak_usage( )/1000000, 1 ) . 'Mb' . PHP_EOL;
	die( );
}
function daystest() {
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
}

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
	logfile( timestamp( display( '#Result: ' ) . display( $thread->name( ) . print_r( $thread->result( ), true ) ) ) );
	$name = $threads->put( $thread );
	$t = $threads->get( $name );
	display( '#Result: ' ) . display( $t->lines( ) );
	display( sprintf( '#Fields (%s): %s', count( $t->fields( ) ), print_r( $t->fields( ), true ) ) );
	display( sprintf( '#Rows (%s): %s', count( $t->rows( ) ), print_r( $t->rows( ), true ) ) );
	}

	function single_thread_test( ) {
		$name = 'TASK0';
#		$command = 'ping -n 5 localhost';
		$command = '"C:\Windows\System32\ping.exe" "localhost"';
		$items = array( );
		$thread = new thread( $command, $name );
		$task = $thread->finish( );
		logfile( timestamp( display( '#Result: ' ) . display( print_r( $task, true ) ) ) );
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
		logfile( timestamp( display( '#Result: ' ) . display( print_r( $task, true ) ) ) );
	}
	
function omni_on_finish_callback( $threads, $thread ) {
	logfile( timestamp( display( '#Result: ' ) . display( $thread->name( ) . print_r( $thread->result( ), true ) ) ) );
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
		case 'ps': display( '#Processes: ' . print_r( $t->processes( ), true) ); break;
		case 'omnidbutil_show_cell_name': display( '#Cell Server: ' . $t->cellserver( ) ); break;
		case 'omnisv_version': display( '#Version: ' . $t->version( ) );
		display( '#Build: ' . $t->build( ) );
		display( '#Timestamp: ' . $t->timestamp( ) );
		break;
		case 'omnisv_status':display( '#Services: ' . print_r( $t->services( ), true ) );
		display( 'Status: ' . $t->status( ) );
		break;
		case 'omnistat':
		case 'omnistat_detail':
		case 'omnistat_previous':
		case 'omnistat_previous_last':
			display( '#Sessions: ' . print_r( $t->sessions( ), true ) );
			break;
		case 'omnistat_session':
		case 'omnistat_session_detail':
			display( '#Devices: ' . print_r( $t->devices( ), true ) );
			display( '#Objects: ' . print_r( $t->objects( ), true ) );
			break;
		case 'omnistat_session_devices':
		case 'omnistat_session_detail_devices':
		case 'omnirpt_session_devices':
			display( '#Devices: ' . print_r( $t->devices( ), true ) );
			break;
		case 'omnistat_session_objects':
		case 'omnistat_session_detail_objects':
		case 'omnidb_session':
		case 'omnidb_session_detail':
		case 'omnirpt_single_session_failed_objects':
		case 'omnirpt_session_objects':
			display( '#Objects: ' . print_r( $t->objects( ), true ) );
			break;
		case 'omnidb_rpt':
		case 'omnidb_rpt_detail':
		case 'omnirpt_single_session_session':
			display( '#Session: ' . print_r( $t->session( ), true ) );
			break;
		case 'omnidb_session_media':
		case 'omnidb_session_media_detail':
		case 'omnirpt_session_media':
			display( '#Media: ' . print_r( $t->media( ), true ) );
			break;
		case 'omnidb_session_report':
		case 'omnirpt_single_session_errors':
			display( '#Errors: ' . print_r( $t->errors( ), true ) );
			break;
		case 'omnirpt_single_session':
			display( '#Session: ' . print_r( $t->session( ), true ) );
			display( '#Failed objects: ' . print_r( $t->objects( ), true ) );
			display( '#Errors: ' . print_r( $t->errors( ), true ) );
			break;
		default:
			display( '#Result: ' ) . display( $t->lines( ) );
			display( sprintf( '#Fields (%s): %s', count( $t->fields( ) ), print_r( $t->fields( ), true ) ) );
			display( sprintf( '#Rows (%s): %s', count( $t->rows( ) ), print_r( $t->rows( ), true ) ) );
	}
	display( '#SQL: ' . $t->SQL( get_class( $t ) ) );
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
	logfile( timestamp( display( '#Result: ' . $thread->name( ) ) . display( print_r( $thread->result( ), true ) ) ) );
	$name = $threads->put( $thread );
	nbu_process( nbu( )->get( $name, $threads->get( $name ) ) );
}

function nbu_process( $t ) {
	if ( !is_object( $t ) ) return FALSE;
	switch ( get_class( $t ) ) {
		case 'bpdbjobs_summary': display( '#Summary: ' . print_r( $t->summary( ), true) ); return; break;
		case 'bpdbjobs_report': display( '#Jobs: ' . count( $t->jobs( ) ) ); break;
		case 'bppllist_policies': 
			display( '#Policies: '. count( $t->policies( ) ) ); 
			display( '#Clients: ' . count( $t->clients( ) ) );
			display( '#Schedules: ' . count( $t->schedules( ) ) );
			break;
		case 'vault_xml':
			display( '#Vault rows: ' . count( $t->rows( ) ) );
			break;
		case 'bpplclients':
			display( '#Clients: ' . count( $t->clients( ) ) );
			break;
		case 'bpimagelist_hoursago': 
			display( '#Images: '. count( $t->images( ) ) ); 
			display( '#Fragments: ' . count( $t->frags( ) ) );
			break;
		default:
			display( '#Result: ' ) . display( $t->lines( ) );
			display( sprintf( '#Fields (%s): %s', count( $t->fields( ) ), print_r( $t->fields( ), true ) ) );
			display( sprintf( '#Rows (%s): %s', count( $t->rows( ) ), print_r( $t->rows( ), true ) ) );
	}
	$sql = $t->SQL( get_class( $t ) );
	is_array( $sql ) || $sql = array( $sql );
	foreach( $sql as $s ) {
		display( '#SQL: ' . $s );
#		display( '#SQL result:' . database( )->execute_query( $s ) );
#		display( '#SQL insert ID:' . database( )->insert_id( ) );
#		display( '#SQL rows:' . database( )->row_count( ) );
#		display( '#SQL info:' . database( )->query_info( ) );
#		display( '#SQL error:' . database( )->error( ) );
#		display( '#SQL message:' . database( )->message( ) );
#		display( '#SQL duration:' . database( )->duration( ) );
	}
}

function nbu_test( $multi_thread = 0 ) {
	nbu( )->home( 'M:\\Veritas' );
	nbu( )->tmp( os( )->path( 'tmp' ) );
	nbu( )->masterserver( 'edc-nbmastc1.res.hpe.com' );
#	nbu_process( bpdbjobs_summary( )->execute( ) );
#	$t = bpdbjobs_report( );
#	$t = bppllist_policies( );
#	$t = bpretlevel( );
#	$t = vault_xml( 'm:\\Veritas\\NetBackup\\db\\vault' );
	$t = bpplclients( );
#	$t = bpimagelist_hoursago( 24 );
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
	logfile( new log_file( os( )->path( 'log/test.log' ) ) );
	debug( new debug_log_file( os( )->path( 'log/debug.log' ) ) );
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

display( '#------' );
display( sprintf( '#Memory used: %sb',os( )->memory( ) ) );
display( sprintf( '#Duration: %sms', os( )->duration( ) ) );
debug( 100, timestamp( 'STOP' ) );
