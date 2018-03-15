<?php

/*
 * MARS 4.0 PHP CODE
* build 4.0.0.0 @ 2016-09-11 00:00
* * rewritten from scratch
*/

class lock_file {
	const LOCK 				= 'PID=%s';
	private $file_name		= NULL;
	private $handle			= 0;
	private $lock			= FALSE;
	
	public    function __construct( $file_name ) {
		$this->file_name( $file_name );
		$this->handle( @fopen( $this->file_name( ), 'w' ) );
	}
	
	public    function file_name( $value = NULL ) { return _var( $this->file_name, func_get_args( ) ); }
	protected function handle( $value = NULL ) { return _var( $this->handle, func_get_args( ) ); }

	public    function lock( $value = NULL ) {
		if ( !isset( $value ) ) return $this->lock;
		if ( $value == $this->lock ) return true;
		if ( $value ) {
			$this->lock = flock( $this->handle( ), LOCK_EX | LOCK_NB ) && fwrite( $this->handle( ), sprintf( static::LOCK, os::pid( ) ) );
		} else {
			$this->lock = !flock( $this->handle( ), LOCK_UN );
		}
		return $this->lock;
	}

	public    function __destruct( ) {
		$this->lock( false );
		fclose( $this->handle( ) );
		@unlink( $this->file_name( ) );
	}
}

class basic_log_file {
	const MAX_SIZE			= 100000;
	const BAK_SUFFIX		= '.bak';
	const CANNOT_OPEN		= 'Cannot open log file %s.';
	const CANNOT_WRITE		= 'Cannot write to log file %s.';
	const CANNOT_CLOSE		= 'Cannot close log file %s.';
	const LOG				= '%s';

	private $file_name		= NULL;
	private $max_size		= 0;
	private $handle			= NULL;
	
	public function __construct( $file_name ) {
		$this->file_name( $file_name );
		$this->max_size( static::MAX_SIZE );
	}

	public function file_name( $value = NULL ) { return _var( $this->file_name, func_get_args( ) ); }
	public function max_size( $value = NULL ) { return _var( $this->max_size, func_get_args( ) ); }
	public function open( ) {
		if ( $this->handle != NULL ) return true;
		if ( !( $file = @fopen( $this->file_name( ),'a' ) ) )
			throw new exception( sprintf( static::CANNOT_OPEN, $this->file_name( ) ) );
		$this->handle = $file;
		return true;
	}
	public function close( ) {
		if ( $this->handle == NULL ) return true;
		if ( !fclose( $this->handle ) ) 
			throw new exception( sprintf( static::CANNOT_CLOSE, $this->file_name( ) ) );
		$this->handle = NULL;
		return true;
	}
	public function write( $content = NULL ) {
		is_array( $content ) && $content = explode( PHP_EOL, $content );
		$content = preg_replace( '/[\r\n]+/', ' ', sprintf( static::LOG, $content ) );
		$file_name = $this->file_name( );
		$size =  file_exists( $file_name ) ? filesize( $file_name ) : 0; 
		if ( $size >= $this->max_size( ) ) {
			rename( $file_name, $file_name . static::BAK_SUFFIX );
			clearstatcache( );
		}
		$this->open( );
		if ( !fwrite( $this->handle, $content . PHP_EOL ) )
			throw new exception( sprintf( static::CANNOT_WRITE, $file_name ) );
		$this->close( );
		return $content;
	}

	public function __destruct( ) {
		return true;
	}
}

class log_file extends basic_log_file {
	const TS_LOG	= '%-16s%-6s%s';
	const TIMESTAMP	= 'Ymd-His';

	public function write( $content = NULL ) {
		$content = preg_replace( '/[\r\n]+/', ' ', sprintf( static::TS_LOG, date( static::TIMESTAMP ), os::pid( ), $content ) );
		return parent::write( $content );
	}
}

class debug_log_file extends log_file {
	const DEBUG_LOG		= '[%3s] %s';
	const DEBUG_LEVEL	= 1;
	private $enabled	= false;
	
	public function enabled( $value = NULL ) { return _var( $this->enabled, func_get_args( ) ); }
	
	public function write( $level, $content = NULL ) {
		if ( !$this->enabled( ) ) return false;
		if ( empty( $content ) ) {
			$content = $level;
			$level = static::DEBUG_LEVEL;
		}
		is_array( $content ) && $content = implode( PHP_EOL, $content );
		$content = sprintf( static::DEBUG_LOG, $level, $content );
		return parent::write( $content );
	}
}

class os {
	const OS_SUPPORTED		= '';
	const OS_UNSUPPORTED	= "Unsupported OS '%s'.";
	const PHP_UNSUPPORTED	= "Unsupported PHP version '%s'.";
	const PRECISION			= 3;
	const TIMESTAMP			= '(+%-5s) %s';

	private $start_time		= 0;
	private $start_memory	= 0;
	private $args			= array( );
	private $root			= NULL;
	
	public function __construct( ) {
		$this->start_time( microtime( TRUE ) );
		$this->start_memory ( memory_get_usage( ) );
		$this->args( $GLOBALS[ 'argv' ] );
		$this->root( dirname( realpath( $this->args[ 0 ] ) ) );
	}

	public function start_time( $value = NULL ) { return _var( $this->start_time, func_get_args( ) ); }
	public function start_memory( $value = NULL ) { return _var( $this->start_memory, func_get_args( ) ); }
	public function args( $field = NULL, $value = NULL ) { return _arr( $this->args, func_get_args( ) ); }
	public function root( $value = NULL ) { return _var( $this->root, func_get_args( ) ); }
	
	public function duration( ) {
		$this->duration = round( microtime( TRUE ) - $this->start_time( ), static::PRECISION );
		return $this->duration;
	}
	
	public static function pid( ) {
		return getmypid( );
	}
	
	public static function name( ) {
		return PHP_OS;
	}

	public static function host( ) {
		return php_uname( 'n' );
	}

	public static function user( ) {
		return get_current_user( );
	}

	public static function is_supported( ) {
		return in_array( PHP_OS, explode(',', static::OS_SUPPORTED ) );
	}

	public static function php( $minimum = NULL ) {
		$result = PHP_VERSION;
		if ( isset( $minimum ) and version_compare( $result, $minimum ) == -1 ) $result = FALSE;
		return $result;
	}

	public function sapi( ) {
		return PHP_SAPI;
	}

	public function memory( ) {
		return memory_get_usage( ) - $this->start_memory( );
	}
	
	public function path( $value = NULL ) {
		if ( is_array( $value ) ) {
			empty( $value ) && $value[ ] = static::root( );
			$value[ 0 ] != static::root( ) && array_unshift( $value , static::root( ) );
			$result = implode( DIRECTORY_SEPARATOR, $value );
		} else {
			$result = static::root( ) . DIRECTORY_SEPARATOR . $value;
		}
		return $result;
	}

	public function processes( ) { 
		return new ps( ); 
	}
	
	public function __destruct( ) {
		unset( $this->args );
	}
}

class os_windows extends os {
	const OS_SUPPORTED = 'WIN32,WINNT,Windows,Windows NT';
}

class os_linux extends os {
	const OS_SUPPORTED = 'Linux,UNIX';
}

class os_hpux extends os {
	const OS_SUPPORTED = 'HP-UX';
}

class task {
	const PID				= 'pid';
	const EXITCODE			= 'exitcode';
	const RUNNING			= 'running';
	const NAME_PATTERN		= '/[^a-zA-Z0-9-_\.]/';
	private $id				= 0;
	private $cmd			= NULL;
	private $name			= NULL;
	private $params			= array( );
	private $status			= array( );
	private $result			= array( );
	
	public function __construct( $cmd, $name = NULL, $params = array( ) ) {
		$this->cmd( $cmd );
		$this->name( preg_replace( static::NAME_PATTERN,'', isset( $name ) ? $name : base64_encode( $cmd ) ) );
		isset( $params ) && $this->params( $params );
	}
	
	public function id( $value = NULL ) { return _var( $this->id, func_get_args( ) ); }
	public function cmd( $value = NULL ) { return _var( $this->cmd, func_get_args( ) ); }
	public function name( $value = NULL ) { return _var( $this->name, func_get_args( ) ); }
	public function params( $field = NULL, $value = NULL ) { return _arr( $this->params, func_get_args( ) ); }
	public function status( $field = NULL, $value = NULL ) { return _arr( $this->status, func_get_args( ) ); }
	public function result( $field = NULL, $value = NULL ) { return _arr( $this->result, func_get_args( ) ); }
	
	public function __destruct( ) {
		unset( $this->params );
		unset( $this->status );
		unset( $this->result );
	}
}

class thread extends task {
	const EXEC					= '%s 2>&1';
	const PRECISION				= 2;
	const PREFIX				= 'thr';
	const SLEEPTIME				= 100;
	const DEBUG_LEVEL			= 100; 
	const DEBUG_STARTED			= 'Thread "%s" started (%s)';
	const DEBUG_FINISHED		= 'Thread "%s" finished (Duration: %ss Exitcode: %s)';

	private $root 				= NULL;
	private $start_time			= 0;
	private $end_time			= 0;
	private $duration			= 0;
	private $stdout				= NULL;
	private $stderr				= NULL;
	private $process			= NULL;

	public function __construct( $cmd, $name = NULL, $params = array( ) ) {
		if ( is_object( $cmd ) ) {
			$params = $cmd->params( );
			$name = $cmd->name( );
			$cmd = $cmd->cmd( );
		}
		parent::__construct( $cmd, $name, $params );
		$this->root( sys_get_temp_dir( ) );
	}
	
	public function root( $value = NULL ) { return _var( $this->root, func_get_args( ) ); }
	public function start_time( $value = NULL ) { return _var( $this->start_time, func_get_args( ) ); }
	public function end_time( $value = NULL ) { return _var( $this->end_time, func_get_args( ) ); }
	protected function stdout( $value = NULL ) { return _var( $this->stdout, func_get_args( ) ); }
	protected function stderr( $value = NULL ) { return _var( $this->stderr, func_get_args( ) ); }
	protected function process( $value = NULL ) { return _var( $this->process, func_get_args( ) ); }

	public function status( $field = NULL, $value = NULL ) {
		is_resource( $this->process( ) ) && $this->status = proc_get_status( $this->process( ) );
		return _arr( $this->status, func_get_args( ) );
	}

	public function duration( ) {
		$microtime = ( $this->end_time( ) == 0 ) ? microtime( TRUE ) : $this->end_time( );
		$this->duration = round( $microtime - $this->start_time( ), static::PRECISION );
		return $this->duration;
	}

	public function execute( ) {
		$this->start_time( microtime( TRUE ) );
		$this->stdout( tempnam( $this->root( ), static::PREFIX ) );
		$this->stderr( tempnam( $this->root( ), static::PREFIX ) );
		$descriptorspec = array(
				1 => array( 'file', $this->stdout, 'w' ),
				2 => array( 'file', $this->stderr, 'w' ),
		);
		debug( static::DEBUG_LEVEL, timestamp( sprintf( static::DEBUG_STARTED, $this->name( ), $this->cmd( ) ) ) );
		if ( $result = $this->process( proc_open( sprintf( static::EXEC, $this->cmd( ) ), $descriptorspec, $pipes ) ) ) $this->status( );
		return $result;
	}

	public function finish( ) {
		is_resource( $this->process( ) ) || $this->execute( );
		while ( $this->status( task::RUNNING ) ) usleep( static::SLEEPTIME );
		$this->end_time( microtime( TRUE ) );
		proc_close( $this->process( ) );
		$this->result( explode( PHP_EOL, file_get_contents( $this->stderr( ) ) . file_get_contents( $this->stdout( ) ) ) );
		unlink( $this->stdout( ) );
		unlink( $this->stderr( ) );
		$this->process( NULL );
		debug( static::DEBUG_LEVEL, timestamp( sprintf( static::DEBUG_FINISHED, $this->name( ), $this->duration( ), $this->status( task::EXITCODE ) ) ) );
		return $this;
	}

	public function __destruct( ) {
		is_resource( $this->process( ) ) && proc_close( $this->process( ) );
		file_exists( $this->stdout( ) ) && unlink( $this->stdout( ) );
		file_exists( $this->stderr( ) ) && unlink( $this->stderr( ) );
		parent::__destruct( );
	}
}

class multi_thread extends thread {
	const BUSY					= 1;
	const IDLE					= 0;
	const FINISHED				= 1;
	const WAITING				= 0;
	const FILENAME				= '%s.thr';
	const DEFAULT_CONCURRENCY	= 4;
	const DEBUG_LEVEL			= 200;
	const DEBUG_ASSIGNED		= 'Thread#%d/%d assigned task#%d/%d (%s)';
	const DEBUG_FINISHED		= 'Thread#%d/%d finished task#%d/%d (%ss)';
	private $concurrency		= NULL;
	private $threads 			= array( );
	private $thread_id			= 0;
	private $tasks 				= array( );
	private $task_id			= 0;
	private $condition_callback	= 'callback';
	private $on_assign_callback	= 'callback';
	private $on_finish_callback	= 'callback';

	public function __construct( $count= NULL ) {
		function callback() {return TRUE;}
		$this->concurrency( isset( $count ) ? $count : static::DEFAULT_CONCURRENCY );
		$this->root( sys_get_temp_dir( ) );
		return TRUE;
	}

	public function concurrency( $value = NULL ) { return _var( $this->concurrency, func_get_args( ) ); }
	protected function threads( $field = NULL, $value = NULL ) { return _arr( $this->threads, func_get_args( ) ); }
	protected function thread_id( $value = NULL ) { return _var( $this->thread_id, func_get_args( ) ); }
	protected function tasks( $field = NULL, $value = NULL ) { return _arr( $this->tasks, func_get_args( ) ); }
	protected function task_id( $value = NULL ) { return _var( $this->task_id, func_get_args( ) ); }
	public function condition_callback( $value = NULL ) { return _var( $this->condition_callback, func_get_args( ) ); }
	public function on_assign_callback( $value = NULL ) { return _var( $this->on_assign_callback, func_get_args( ) ); }
	public function on_finish_callback( $value = NULL ) { return _var( $this->on_finish_callback, func_get_args( ) ); }

	public function execute( ) {
		$this->threads( array_fill( 0, $this->concurrency( ), NULL ) );
		$this->start_time( microtime( TRUE ) );
		while ( call_user_func( $this->condition_callback( ), $this ) and ( $this->count_tasks( static::WAITING ) or $this->count_threads( static::BUSY ) ) ) {
			if ( $this->count_tasks( static::WAITING ) and $this->count_threads( static::IDLE ) ) {
				$thread = $this->assign( );
				debug( static::DEBUG_LEVEL, timestamp( sprintf( static::DEBUG_ASSIGNED, $this->thread_id( ) + 1, $this->count_threads( ), $thread->id( ), $this->count_tasks( ), $thread->cmd( ) ) ) );
				call_user_func( $this->on_assign_callback( ), $this, $thread );
			}
			if ( $this->count_threads( static::BUSY ) ) {
				if ( $this->is_finished( ) ) {
					$thread = $this->release( );
					debug( static::DEBUG_LEVEL, timestamp( sprintf( static::DEBUG_FINISHED, $this->thread_id( ) + 1, $this->count_threads( ), $thread->id( ), $this->count_tasks( ), $thread->duration( ) ) ) );
					call_user_func( $this->on_finish_callback( ), $this, $thread );
				}
				$this->thread_id( $this->next_thread_id( static::BUSY, $this->thread_id( ) + 1 ) );
			}
			usleep( static::SLEEPTIME );
		}
		$this->end_time( microtime( TRUE ) );
	}

	public function count_threads( $state = NULL ) {
		$result = $this->concurrency( );
		$i = $b = 0;
		foreach( $this->threads( ) as $thread ) {
			is_object( $thread ) ? $b++ : $i++;
		}
		$state === static::IDLE && $result = $i;
		$state === static::BUSY && $result = $b;
		return $result;

	}

	protected function next_thread_id( $state, $start = 0 ) {
		$i = 0;
		$count = $this->count_threads( );
		$found = FALSE;
		while( ( $i < $count ) and !$found ) {
			$index = ( $i + $start ) % $count;
			$isobject = is_object( $this->threads( $index ) );
			$state === static::IDLE && $found = !$isobject;
			$state === static::BUSY && $found = $isobject;
			$i++;
		}
		return $found ? $index : FALSE;
	}

	protected function assign( ) {
		$i = $this->next_thread_id( static::IDLE );
		$thread = new thread( $this->tasks( $this->task_id( ) ) );
		$thread->root( $this->root( ) );
		$this->task_id( $thread->id( $this->task_id( ) + 1 ) );
		$thread->execute( ) && 	$this->threads( $this->thread_id( $i ), $thread );
		return $thread;
	}

	public function get( $name ) {
		$thread = FALSE;
		$file = sprintf( static::FILENAME, $this->root( ) . DIRECTORY_SEPARATOR . $name );
		if ( file_exists( $file ) ) {
			$thread = unserialize( file_get_contents( $file ) );
			unlink( $file );
		}
		return $thread;
	}

	public function put( $thread ) {
		$name = $thread->name( );
		$file = sprintf( static::FILENAME, $this->root( ) . DIRECTORY_SEPARATOR . $name );
		file_put_contents( $file, serialize( $thread ) ) || $name = FALSE;
		return $name;
	}

	protected function is_finished( ) {
		$result = FALSE;
		if ( $thread = $this->threads( $this->thread_id( ) ) ) $result = !$thread->status( task::RUNNING );
		return $result;
	}

	protected function release( ) {
		if( $thread = $this->threads( $this->thread_id( ) ) ) {
			$this->threads( $this->thread_id( ), static::IDLE );
			$thread->finish( );
		}
		return $thread;
	}

	public function count_tasks( $state = NULL ) {
		$result = count( $this->tasks( ) );
		$state === static::FINISHED && $result = $this->task_id( );
		$state === static::WAITING && $result = $result - $this->task_id( );
		return $result;
	
	}
	
	public function queue( $task, $immediately = FALSE ) {
		foreach ( $this->tasks( ) as $t ) {
			if ( $t->cmd( ) == $task->cmd( ) ) return FALSE;
		}
		$task->id( $this->count_tasks( ) + 1 );
		if ( $immediately ) {
			array_splice( $this->tasks( ), $this->task_id( ), 0, array( $task ) );
		} else {
			$this->tasks( NULL, $task );
		}
		return TRUE;
	}

	public function finish( ) {
		return TRUE;
	}
	
	public function __destruct( ) {
		unset( $this->threads );
		unset( $this->tasks );
		parent::__destruct( );
	}
}

class field {
	const NAME					= 'name';
	const TYPE					= 'type';
	const STRING				= 'string';
	const DATETIME				= 'datetime';
	const INTEGER				= 'int';
	const REAL					= 'real';
	const TIME					= 'time';
	const DATETIME_FORMAT		= 'Y-m-d H:i:s';
	const DATE_FORMAT			= 'Y-m-d';
	const TIME_FORMAT			= 'H:i:s';

	private $value				= NULL;
	private $type				= NULL;

	public function __construct( $value = NULL, $type = NULL ) {
		$this->type( isset( $type ) ? $type : static::STRING );
		$this->value( $value );
	}

	public function type( $value = NULL ) { return _var( $this->type, func_get_args( ) ); }
	public function value( $value = NULL ) { return $this->validate( _var( $this->value, $value ), $this->type( ) ); }

	public static function validate( $value = NULL, $type = NULL ) {
		switch ( $type ) {
			case static::DATETIME:
				$value = ( strtotime( $value ) == 0 ) ? NULL : date( static::DATETIME_FORMAT, strtotime( $value ) );
				break;
			case static::INTEGER:
				$value = ( $value == '-' or $value == '' ) ? 0 : intval( $value );
				break;
			case static::REAL:
				$value = ( $value == '-' or $value == '' ) ? 0 : floatval( $value );
				break;
			case static::TIME:
				$value = empty( $value ) ? NULL : date( static::TIME_FORMAT, strtotime( $value ) );
				break;
			default: $value = trim( $value );
		}
		return $value;
	}

	public function __destruct( ) {
		return true;
	}
}

class text {
	const PATTERN				= '^%s$';
	const NEW_LINE				= '\r?\n';
	const DOUBLE_NEW_LINE		= '\r?\n\r?\n';
	const NUMBER				= '\d+?';
	const WORD					= '\w+?';
	const STRING				= '\S+?';
	const SPACES				= '\s+';
	const ALL					= '.+?';
	const CSV					= '.*?(?<!\\\)';
	const COMMA					= ',';
	const TEXT					= '(.+(\r?\n)?)+';
	const XML					= '<?xml version="1.0" encoding="UTF-8" ?>';
	const PARSING_ERROR			= 'Parsing error at item#%s: "%s"';
	const PARSING_EXCEPTION		= 'Exception: %d parsing error(s) encountered: %s';
	private $row_delimiter		= NULL;
	private $field_pattern		= NULL;
	private $lines				= array( );
	private $fields				= array( );
	private $rows				= array( );
	private $add_fields			= array( );
	private $remove_fields		= array( );
	private $ignore_lines		= array( );
	private $parsing_errors		= array( );

	public function __construct( $lines = NULL ) {
		$this->lines( is_array( $lines ) ? $lines : explode( PHP_EOL, $lines ) );
		$this->setup( );
		$this->parse( );
	}

	public function row_delimiter( $value = NULL ) { return _var( $this->row_delimiter, func_get_args( ) ); }
	public function field_pattern( $value = NULL ) { return _var( $this->field_pattern, func_get_args( ) ); }
	public function lines( $field = NULL, $value = NULL ) { return _arr( $this->lines, func_get_args( ) ); }
	public function fields( $field = NULL, $value = NULL ) { return _arr( $this->fields, func_get_args( ) ); }
	public function add_fields( $field = NULL, $value = NULL ) { return _arr( $this->add_fields, func_get_args( ) ); }
	public function remove_fields( $field = NULL, $value = NULL ) { return _arr( $this->remove_fields, func_get_args( ) ); }
	public function rows( $field = NULL, $value = NULL ) { return _arr( $this->rows, func_get_args( ) ); }
	public function ignore_lines( $field = NULL, $value = NULL ) { return _arr( $this->ignore_lines, func_get_args( ) ); }
	public function parsing_errors( $field = NULL, $value = NULL ) { return _arr( $this->parsing_errors, func_get_args( ) ); }
	public static function pattern( ) { return static::P( field::NAME ); }

	protected function setup( ) {
		$this->row_delimiter( static::NEW_LINE );
		$this->field_pattern( static::pattern( ) );
	}

	public function parse( ) {
		$this->parse_fields( );
		$this->parse_rows( );
		return $this;
	}

	protected function parse_fields( ) {
		$fields = array( );
		preg_match_all( sprintf( '/P\<%s\>/m', static::P( field::NAME ) ), $this->field_pattern( ), $names );
		$names = array_unique( array_merge( array_keys( $this->add_fields( ) ), $names[ field::NAME ] ) );
		foreach ( $names as $name ) {
			$type = $this->fields( $name );
			$fields[ $name ] = empty( $type ) ? field::STRING : $type;
		}
		foreach ( $this->remove_fields( ) as $name ) {
			if ( !empty( $fields[ $name ] ) ) unset( $fields[ $name ] );
		}
		return count( $this->fields( $fields ) );
	}

	protected function parse_split( $split ) {
		$result = FALSE;
		if ( preg_match( sprintf( '/%s/m', $this->field_pattern( ) ), $split, $match ) ) {
			$result = array( );
			foreach ( $this->fields( ) as $name => $type ) {
				$result[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
			}
		}
		return $result;
	}
	
	protected function parse_rows( ) {
		$lines = $this->lines( );
		$rows = $this->rows( );
		$i = 1;
		foreach( preg_split( sprintf( '/%s/m', $this->row_delimiter( ) ), implode( PHP_EOL, $lines ) ) as $split ) {
			$split = trim( $split );
			$ignore = FALSE;
			foreach( $this->ignore_lines( ) as $ignore_line ) {
				$ignore = $ignore || preg_match( sprintf( '/%s/m', $ignore_line ), $split, $match );
			}
			if ( empty( $split ) or $ignore ) continue;
			$result = $this->parse_split( $split );
			if ( $result === FALSE ) {
				$this->parsing_errors( NULL, sprintf( static::PARSING_ERROR, $i, $split ) );
			} else {
#				isset( $result[ 0 ] ) && !is_array( $result[ 0 ] ) && $result = array( $result );
				is_array( current( $result ) ) || $result = array( $result );
				foreach( $result as $r ) count( $r ) > 0 && $rows[ ] = $r;
			}
			$i++;
		}
		if ( $this->parsing_errors( ) )
			throw new Exception( sprintf( static::PARSING_EXCEPTION, count( $this->parsing_errors( ) ), get_class( $this ) . implode( PHP_EOL, $this->parsing_errors( ) ) ) );
			return count( $this->rows( $rows ) );
	}

	public static function P( $name, $pattern = NULL ) {
		return sprintf( '(?P<%s>%s)', $name, isset( $pattern ) ? $pattern : static::STRING );
	}

	public function XML( $row = NULL ) {
		isset( $row ) || $row = static::XML-ROW;
		if ( count( $this->rows ) == 0 ) return FALSE;
		$result = array ( static::XML );
		$result[ ] = sprintf( '<%ss>', $row );
		foreach( $this->rows( ) as $id => $fields ) {
			if ( count( $fields ) == 0 ) continue;
			$result[ ] = sprintf( '<%s>', $row );
			foreach ( $fields as $field => $value ) {
				$result[ ] = sprintf( '<%s>%s</%s>',$field, $value, $field );
			}
			$result[ ] = sprintf( '</%s>', $row );
		}
		$result[ ] = sprintf( '</%ss>', $row );
		return implode( PHP_EOL, $result );
	}

	public function SQL( $table = NULL ) {
		$count = count( $this->rows( ) ); 
		if ( $count == 0 ) return FALSE;
		$fieldlist = array( );
		$update = array( );
		foreach( $this->fields( ) as $name => $type ) {
			$fieldlist[ ] = sprintf( '`%s`', $name );
			$update[ ] = sprintf( '`%s`=values(`%s`)', $name, $name );
		}
		$result = array( );
		$values = array( );
		foreach( $this->rows( ) as $id => $fields ) {
			if ( count( $fields ) == 0 ) continue;
			$row = array( );
			foreach ( $fields as $field => $value ) {
				$row[ ] = $value === '' ? 'NULL' : sprintf( "'%s'", $value );
			}
			$values[ ] = sprintf( '(%s)', implode( ',', $row ) );
			if ( ( ( $id + 1 ) % 256 == 0 ) or ( ( $id + 1 ) == $count ) ) {
				$result[ ] = sprintf( "insert ignore into `%s` (%s) values\n%s\non duplicate key update %s;", 
					isset( $table ) ? $table : 'table' , 
					implode( ',', $fieldlist ), implode( ',' . PHP_EOL, $values ), 
					implode( ',', $update ) );
				$values = array( );
			}
		}
		return $result;
	}

	public function __destruct( ) {
		unset( $lines );
		unset( $fields );
		unset( $rows );
		unset( $add_fields );
		unset( $remove_fields );
		unset( $ignore_lines );
		unset( $parsing_errors );
	}
}

class cmd extends text {
	const ARGUMENTS				= '%s';
	const UX_PATH				= NULL;
	const WIN_PATH				= NULL;
	const UX_BIN				= NULL;
	const WIN_BIN				= NULL;
	const VALID_EXITCODES		= '0';
	const EXECUTION_EXCEPTION	= 'Exception: Execution error encoutered. Exitcode: %s Output: %s';
	private $arguments			= NULL;
	private $cmdline			= NULL;
	private $tmp				= NULL;
	
	public function arguments( $value = NULL ) { return _var( $this->arguments, func_get_args( ) ); }
	public function cmdline( $value = NULL ) { return _var( $this->cmdline, func_get_args( ) ); }
	public function tmp( $value = NULL ) { return _var( $this->tmp, func_get_args( ) ); }
	
	public function __construct( $arguments = NULL ) {
		$this->arguments( $arguments );
		$this->cmdline( $this->command( $this->arguments( ) ) );
		$this->tmp( sys_get_temp_dir( ) );
		$this->setup( );
	}

	public function parse( $lines = NULL ) {
		$this->lines( is_array( $lines ) ? $lines : explode( PHP_EOL, $lines ) );
		return parent::parse( );
	}

	public static function command( $arguments = NULL ) {
		if ( os_hpux::is_supported( ) ) {
			$home = static::UX_PATH;
			$bin = static::UX_BIN;
		}
		if ( os_linux::is_supported( ) ) {
			$home = static::UX_PATH;
			$bin = static::UX_BIN;
		}
		if ( os_windows::is_supported( ) ) {
			$home = static::WIN_PATH;
			$bin = static::WIN_BIN;
		}
		$cmd = escapeshellarg( $home . ( !empty( $home ) ? DIRECTORY_SEPARATOR : '' ) . $bin );
		$arguments = sprintf( ' ' . static::ARGUMENTS, is_array( $arguments ) ? implode( ' ', $arguments ) : $arguments );
		return trim( $cmd . $arguments );
	}

	public function put( $object ) {
		$result = FALSE;
		$file = tempnam( $this->tmp( ), static::PREFIX );
		file_put_contents( $file, serialize( $object ) ) && $result = basename( $file, '.tmp' );
		return $result;
	}
	
	public function get( $name, $task ) {
		$object = FALSE;
		$file = $this->tmp( ) . DIRECTORY_SEPARATOR . $name . '.tmp';
		if ( file_exists( $file ) ) {
			$object = unserialize( file_get_contents( $file ) );
			unlink( $file );
			if ( !in_array( $task->status( task::EXITCODE ), explode( ',', $object::VALID_EXITCODES ) ) )
				throw new exception( sprintf( cmd::EXECUTION_EXCEPTION, $task->status( task::EXITCODE ), implode( $task->result( ) ) ) );
				$object->parse( $task->result( ) );
		}
		return $object;
	}
	
	public function execute( $threads = NULL ) {
		if ( isset( $threads ) ) {
			$result = $threads->queue( new task( $this->cmdline( ), $this->put( $this ) ) );
		} else {
			$thread = new thread( $this->cmdline( ) );
			$thread->finish( );
			if ( !in_array( $thread->status( task::EXITCODE ), explode( ',', $this::VALID_EXITCODES ) ) )
				throw new exception( sprintf( static::EXECUTION_EXCEPTION, $thread->status( task::EXITCODE ), implode( $thread->result( ) ) ) );
			$result = $this->parse( $thread->result( ) );
		}
		return $result;
	}
}

class ps extends cmd {
	const UX_PATH		= NULL;
	const UX_BIN		= 'ps';
	const WIN_PATH		= 'M:\\Omniback\\bin';
	const WIN_BIN		= 'ps';
	const UID			= 'UID';
	const PID			= 'PID';
	const PPID			= 'PPID';
	const C				= 'C';
	const STIME			= 'STIME';
	const TTY			= 'TTY';
	const TIME			= 'TIME';
	const CMD			= 'CMD';

	private $processes = array( );

	public function processes( $field = NULL, $value = NULL ) { return _arr( $this->processes, func_get_args( ) ); }

	public static function pattern( ) {
		$pattern= array(
				text::P( ps::UID ),
				text::P( ps::PID ),
				text::P( ps::PPID ),
				text::P( ps::C ),
				text::P( ps::STIME ),
				text::P( ps::TTY ),
				text::P( ps::TIME ),
				text::P( ps::CMD, text::ALL ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->field_pattern( static::pattern( ) );
		$this->fields( ps::PID, field::INTEGER );
		$this->fields( ps::PPID, field::INTEGER );
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->processes( $row[ ps::PID ], $row );
	}
}

#--------------------------------------------------------------------------------------------------
function os( ) { global $os; return $os; }

function _var( &$variable, $args ) {
	count( $args ) == 1 && $variable = $args[ 0 ];
	return $variable;
}

function _arr( &$array, $args ) {
	if ( count( $args ) == 2 ) {
		( $args[ 0 ] === NULL ) ? $array[ ] = $args[ 1 ] : $array[ $args[ 0 ] ] = $args[ 1 ];
		return $args[ 1 ];
	}
	if ( count( $args ) == 1 ) {
		if ( is_array( $args[ 0 ] ) ) {
			$array = $args[ 0 ];
			return $args[ 0 ];
		}
		return isset( $array[ $args[ 0 ] ] ) ? $array[ $args[ 0 ] ] : FALSE;
	}
	return $array;
}

function timestamp( $content = NULL ) {
	is_array( $content ) && $content = implode( PHP_EOL, $content ) ;
	return sprintf( os::TIMESTAMP, os( )->duration( ), $content );
}

function display( $content = NULL ) {
	$result = is_array( $content ) ? implode( PHP_EOL, $content ) : $content;
	echo $result . PHP_EOL;
	return $result;
}

function logfile( $content = NULL ) {
	global $logfile;
	if ( !isset( $content ) ) return $logfile;
	if ( is_object( $content ) ) {
		$logfile = $content;
		return $logfile;
	}
	return $logfile->write( $content );
}

function debug( $level = NULL, $content = NULL ) {
	global $debug;
	if ( !isset( $level ) and !isset( $content ) ) return $debug;
	if ( is_object( $level ) ) {
		$debug = $level;
		return $debug;
	}
	return $debug->write( $level, $content );
}

date_default_timezone_set( @date_default_timezone_get( ) );
$os = NULL;
if ( os_hpux::is_supported( ) ) $os = new os_hpux( );
if ( os_linux::is_supported( ) ) $os = new os_linux( );
if ( os_windows::is_supported( ) ) $os = new os_windows( );
if ( empty( $os ) )	throw new exception( sprintf( os::OS_UNSUPPORTED, os::name( ) ) );
