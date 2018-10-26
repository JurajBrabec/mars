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