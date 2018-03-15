<?php

/*
 * MARS 4.0 PHP CODE
* build 4.0.0.0 @ 2016-09-11 00:00
* * rewritten from scratch
*/

require_once dirname( __FILE__ ) . '/os.php';

class sql_database {
	const NAME = 'Generic SQL';
	const ERROR = '%s. %s error %s: "%s"';
	const NOT_CONNECTED = 'Database not connected';
	const INFO = '%s database';
	const CONNECTED = '%s database "%s@%s" connected.';
	const DURATION_PRECISION = 3;
	const SELECTED = 'Database "%s" selected.';
	const CHARSET_SET = 'Charset "%s" set.';
	const STRING_ESCAPED = 'String "%s" escaped.';
	const QUERY_EXECUTED = 'Query #%s executed.';
	const QUERY_FREE = 'Query #%s results released.';
	
	private $host = NULL;
	private $user = NULL;
	private $password = NULL;
	private $database = NULL;
	private $handler = NULL;
	private $db_info = NULL;
	private $error = 0;
	private $message = NULL;
	private $charset = NULL;
	private $queries = 0;
	private $durations = 0;
	private $sql = NULL;
	private $query = NULL;
	private $field_count = 0;
	private $fields = array( );
	private $row_count = 0;
	private $rows = array( );
	private $insert_id = 0;
	private $duration = 0;
	private $query_info = NULL;

	public function host( $value = NULL ) { return _var( $this->host, func_get_args( ) ); }
	public function user( $value = NULL ) { return _var( $this->user, func_get_args( ) ); }
	public function password( $value = NULL ) { return _var( $this->password, func_get_args( ) ); }
	public function database( $value = NULL ) { return _var( $this->database, func_get_args( ) ); }
	protected function handler( $value = NULL ) { return _var( $this->handler, func_get_args( ) ); }
	public function db_info( $value = NULL ) { return _var( $this->db_info, func_get_args( ) ); }
	public function error( $value = NULL ) { return _var( $this->error, func_get_args( ) ); }
	public function message( $value = NULL ) { return _var( $this->message, func_get_args( ) ); }
	public function charset( $value = NULL ) { return _var( $this->charset, func_get_args( ) ); }
	public function queries( $value = NULL ) { return _var( $this->queries, func_get_args( ) ); }
	public function durations( $value = NULL ) { return _var( $this->durations, func_get_args( ) ); }
	public function sql( $value = NULL ) { return _var( $this->sql, func_get_args( ) ); }
	protected function query( $value = NULL ) { return _var( $this->query, func_get_args( ) ); }
	public function field_count( $value = NULL ) { return _var( $this->field_count, func_get_args( ) ); }
	public function fields( $field = NULL, $value = NULL ) { return _arr( $this->fields, func_get_args( ) ); }
	public function row_count( $value = NULL ) { return _var( $this->row_count, func_get_args( ) ); }
	public function rows( $field = NULL, $value = NULL ) { return _arr( $this->rows, func_get_args( ) ); }
	public function insert_id( $value = NULL ) { return _var( $this->insert_id, func_get_args( ) ); }
	public function duration( $value = NULL ) { return _var( $this->duration, func_get_args( ) ); }
	public function query_info( $value = NULL ) { return _var( $this->query_info, func_get_args( ) ); }
	
	public function __construct( $host = NULL, $user = NULL, $password = NULL ) {
		$this->host( $host );
		$this->user( $user );
		$this->password( $password );
		$this->db_info( sprintf( sql_database::INFO, static::NAME ) );
		$this->message( sprintf( static::CONNECTED, static::NAME, $this->user( ), $this->host( ) ) );
	}

	public function is_connected() {
		return is_resource( $this->handler( ) );
	}

	public function select_database( $database ) {
		if ( !$this->is_connected( ) ) {throw new exception( 
			sprintf( static::ERROR, static::NOT_CONNECTED, static::NAME, $this->error( ), $this->message( ) ) );}
		$this->database( $database );
		$this->error( 0 );
		$this->message( sprintf( static::SELECTED, $this->database( ) ) );
		$this->sql( NULL );
		$this->query( NULL );
		$this->field_count( 0 );
		$this->fields( array( ) );
		$this->row_count( 0 );
		$this->rows( array( ) );
		$this->insert_id( 0 );
		$this->duration( 0 );
		$this->query_info( NULL );
	}

	public function set_charset( $charset ) {
		if ( !$this->is_connected( ) ) {throw new exception(
				sprintf( static::ERROR, static::NOT_CONNECTED, static::NAME, $this->error( ), $this->message( ) ) );}
		$this->charset( $charset );
		$this->error( 0 );
		$this->message( sprintf( static::CHARSET_SET, $this->charset( ) ) );
	}

	public function escape_string( $string ) {
		if ( !$this->is_connected( ) ) {throw new exception(
				sprintf( static::ERROR, static::NOT_CONNECTED, static::NAME, $this->error( ), $this->message( ) ) );}
		$this->error( 0 );
		$this->message( sprintf( static::STRING_ESCAPED, $string ) );
		return $string;
	}

	public function execute_query( $sql ) {
		if ( !$this->is_connected( ) ) {throw new exception(
				sprintf( static::ERROR, static::NOT_CONNECTED, static::NAME, $this->error( ), $this->message( ) ) );}
		$this->queries( $this->queries( ) + 1 );
		$this->sql( $sql );
		$this->query( NULL );
		$this->error ( 0 );
		$this->message ( sprintf( static::QUERY_EXECUTED, $this->queries( ) ) );
		$this->field_count( 0 );
		$this->fields( array( ) );
		$this->row_count( 0 );
		$this->rows( array( ) );
		$this->insert_id( 0 );
		$this->duration( microtime( true ) );
		$this->query_info( NULL );
	}

	public function free_query() {
		if ( !$this->is_connected( ) ) {throw new exception(
				sprintf( static::ERROR, static::NOT_CONNECTED, static::NAME, $this->error( ), $this->message( ) ) );}
		$this->sql( NULL );
		$this->query( NULL );
		$this->error( 0 );
		$this->message( sprintf( static::QUERY_FREE, $this->queries( ) ) );
		$this->field_count( 0 );
		$this->fields( array( ) );
		$this->row_count( 0 );
		$this->rows( array( ) );
		$this->insert_id( 0 );
		$this->duration( 0 );
		$this->query_info( NULL );
	}
}

class mysql_database extends sql_database {
	const NO_SUPPORT = 'MySQL support not installed in PHP.';
	const NAME = 'MySQL';
	const HOST = '127.0.0.1';
	const USER = 'root';
	const PASSWORD = '';
	const DATABASE = 'mysql';
	const ERROR = '%s. %s error %s: "%s" (%s. try) in "%s".';
	const INFO = '%s database %s on %s';
	const NOT_SELECTED = 'Database not selected';
	const CHARSET_NOT_SET = 'Charset not set';
	const STRING_NOT_ESCAPED = 'String not escaped';
	const QUERY_NOT_EXECUTED = 'Query not executed';
	const QUERY_NOT_FREE = 'Query results not freed';
	const ROWS_SELECTED = 'Rows selected: %s';
	const RETRY_ERRORS = '1205,1213';
	const RETRY_DELAY = 100000;
	const RETRY_MAX = 3;
	const START_TRANSACTION = 'START TRANSACTION;';
	const COMMIT = 'COMMIT;';
	
	public function __construct( $host = NULL, $user = NULL, $password = NULL ) {
		isset( $host ) || $host = static::HOST;
		isset( $user ) || $host = static::USER;
		isset( $password ) || $host = static::PASSWORD;
		if ( !mod_mysql( ) ) throw new exception( static::NO_SUPPORT );
		parent::_construct( $host, $user, $password );
		$this->handler( mysql_connect( $this->host( ), $this->user( ), $this->password( ) ) );
		if ( !$this->is_connected( ) ) {
			$this->handler( NULL );
			$this->db_info( $this->message( ) );
			$this->error( mysql_errno( ) );
			$this->message( trim( mysql_error( ) ) );
			throw new exception( sprintf( static::ERROR, static::NOT_CONNECTED, static::NAME, $this->error( ), $this->message( ) ) );
		}
		$this->db_info( sprintf( mysql_database::INFO, static::NAME, 
			mysql_get_server_info( $this->handler( ) ),	mysql_get_host_info( $this->handler( ) ) ) );
		return true;
	}

	public function select_database( $database ) {
		parent::select_database( $database );
		if ( !mysql_select_db( $database, $this->handler( ) ) ) {
			$this->database( NULL );
			$this->error( mysql_errno( $this->handler( ) ) );
			$this->message( trim( mysql_error( $this->handler( ) ) ) );
			throw new exception( sprintf( static::ERROR, static::NOT_SELECTED, static::NAME, $this->error( ), $this->message( ) ) );
		}
		return $this->database( );
	}

	public function set_charset( $charset ) {
		parent::set_charset( $charset );
		if ( !mysql_set_charset( $charset, $this->handler( ) ) ) {
			$this->charset( NULL );
			$this->error( mysql_errno( $this->handler( ) ) );
			$this->message( trim( mysql_error( $this->handler( ) ) ) );
			throw new exception( sprintf( static::ERROR, static::CHARSET_NOT_SET, static::NAME, $this->error( ), $this->message( ) ) );
		}
		return $this->charset( );
	}

	public function escape_string( $string ) {
		$result = mysql_real_escape_string( parent::escape_string( $string ), $this->handler( ) );
		if ( $result === FALSE ) {
			$this->error( mysql_errno( $this->handler( ) ) );
			$this->message( trim( mysql_error( $this->handler( ) ) ) );
			throw new exception( sprintf( static::ERROR, static::STRING_NOT_ESCAPED, static::NAME, $this->error( ), $this->message( ) ) );
		}
		return $result;
	}

	public function execute_query( $sql = '', $values = array( ) ) {
		krsort( $values );
		foreach ( $values as $key => $value ) {
			$sql = str_replace( '%' . $key, $value, $sql );
		}
		parent::execute_query( $sql );
		$try = 0;
		while ( $this->query( ) === NULL ) {
			usleep( $try * static::RETRY_DELAY );
			$try++;
			!$this->query( mysql_query( $this->sql( ), $this->handler( ) ) ) && ( $try < static::RETRY_MAX ) &&
				 in_array( mysql_errno( $this->handler( ) ), explode( ',', static::RETRY_ERRORS ) ) && $this->query( NULL );
		}
		if ( !$this->query( ) ) {
			$this->duration( 0 );
			$this->error( mysql_errno( $this->handler( ) ) );
			$this->message( trim( mysql_error( $this->handler( ) ) ) );
			throw new exception( 
				sprintf( static::ERROR, static::QUERY_NOT_EXECUTED, static::NAME, $this->error( ), $this->message( ), $try, $this->sql( ) ) );
		}
		if ( is_resource( $this->query( ) ) ) {
			$this->field_count( mysql_num_fields( $this->query( ) ) );
			while ( $field = mysql_fetch_field( $this->query( ) ) ) {
				$this->fields( NULL, $field );
			}
			$this->row_count( mysql_num_rows( $this->query( ) ) );
			while ( $row = mysql_fetch_array( $this->query( ) ) ) {
				$this->rows( NULL, $row );
			}
			$this->query_info( sprintf( static::ROWS_SELECTED, $this->row_count( ) ) );
		} else {
			$this->query_info( mysql_info( $this->handler( ) ) );
			$this->row_count( mysql_affected_rows( $this->handler( ) ) );
			$this->insert_id( mysql_insert_id( $this->handler( ) ) );
		}
		$this->duration( round( microtime( true ) - $this->duration( ), static::DURATION_PRECISION ) );
		$this->durations( $this->durations( ) + $this->duration( ) );
		return $this->row_count( );
	}

	public function start_transaction( ) {
		return $this->execute_query( static::START_TRANSACTION );
	}
	
	public function commit( ) {
		return $this->execute_query( static::COMMIT );
	}
	
	public function free_query( ) {
		$query = $this->query( );
		parent::free_query( );
		if ( is_resource( $query ) and !mysql_free_result( $query ) ) {
			$this->error( mysql_errno( $this->handler( ) ) );
			$this->message( trim( mysql_error( $this->handler ) ) );
			throw new exception( sprintf( static::ERROR, static::QUERY_NOT_FREE, static::NAME, $this->error( ), $this->message( ) ) );
		}
		return true;
	}
}

class mysqli_database extends mysql_database {
	const NO_SUPPORT = 'MySQLi support not installed in PHP.';
	const NAME = 'MySQLi';
	const STRING = 'string';
	const INT = 'int';
	const REAL = 'real';
	const TIMESTAMP = 'timestamp';
	const DATETIME = 'datetime';
	const BLOB = 'blob';
	const OTHER = 'other';
	const PORT = 3306;
	
	private $port = NULL;

	public function port( $value = NULL ) { return _var( $this->port, func_get_args( ) ); }
	
	public function __construct( $host = NULL, $user = NULL, $password = NULL, $database = NULL, $port = NULL ) {
		if ( !mod_mysqli( ) ) throw new exception( static::MYSQLI_NO_SUPPORT );
		sql_database::__construct( $host, $user, $password );
		isset( $database ) || $database = static::DATABASE;
		isset( $port ) || $port = static::PORT;
		$this->database( $database );
		$this->port( $port );
		$this->handler( @new mysqli( $this->host( ), $this->user( ), $this->password( ), $this->database( ), $this->port( ) ) );
		if ( !$this->is_connected( ) ) {
			$this->db_info( $this->message( ) );
			if ( version_compare( phpversion( ), '5.3.0', '>=' ) ) {
				$this->error( $this->handler( )->errno );
				$this->message( trim( $this->handler( )->error ) );
			} else {
				$this->error( mysqli_connect_errno( ) );
				$this->message( trim( mysqli_connect_error( ) ) );
			}
			$this->handler(NULL );
			throw new exception( sprintf( static::ERROR, static::NOT_CONNECTED, static::NAME, $this->error( ), $this->message( ) ) );
		}
		$this->db_info( sprintf( mysqli_database::INFO, static::NAME, $this->handler( )->client_info, $this->handler( )->host_info ) );
		return true;
	}

	public function is_connected( ) {
		$result = FALSE;
		if ( version_compare( phpversion( ), '5.3.0', '>=') ) {
			$result = !$this->handler( )->connect_error;
		} else {
			$result = !mysqli_connect_error( );
		}
		return $result;
	}
	
	public function select_database( $database ) {
		sql_database::select_database( $database );
		if ( !$this->handler( )->select_db( $database ) ) {
			$this->database( NULL );
			$this->error( $this->handler( )->errno );
			$this->message( trim( $this->handler( )->error ) );
			throw new exception( sprintf( static::ERROR, static::NOT_SELECTED, static::NAME, $this->error( ), $this->message( ) ) );
		}
		return $this->database( );
	}

	public function set_charset( $charset ) {
		sql_database::set_charset( $charset );
		if ( !$this->handler( )->set_charset( $charset ) ) {
			$this->charset( NULL );
			$this->error( $this->handler( )->errno );
			$this->message( trim( $this->handler( )->error ) );
			throw new exception( sprintf( static::ERROR, static::CHARSET_NOT_SET, static::NAME, $this->error( ), $this->message( ) ) );
		}
		return $this->charset( );
	}

	public function escape_string( $string ) {
		$result = $this->handler( )->escape_string( sql_database::escape_string( $string ) );
		if ( $result === FALSE ) {
			$this->error( $this->handler( )->errno );
			$this->message( trim( $this->handler( )->error ) );
			throw new exception( sprintf( static::ERROR, static::STRING_NOT_ESCAPED, static::NAME, $this->error( ), $this->message( ) ) );
		}
		return $result;
	}

	public function execute_query( $sql = '', $values = array( ) ) {
		krsort( $values );
		foreach ( $values as $key => $value ) {
			$sql = str_replace( '%' . $key, $value, $sql );
		}
		sql_database::execute_query( $sql );
		$try = 0;
		while ( $this->query( ) === NULL ) {
			usleep( $try * static::RETRY_DELAY );
			$try++;
			( $this->query( $this->handler( )->query( $this->sql( ) ) ) === NULL ) && 
				( $try < static::RETRY_MAX ) && in_array( $this->handler( )->errno, explode( ',', static::RETRY_ERRORS ) ) && 
				$this->query( NULL );
		}
		if ( $this->query( ) === NULL ) {
			$this->duration( 0 );
			$this->error( $this->handler( )->errno );
			$this->message( trim( $this->handler( )->error ) );
			throw new exception(
				sprintf( static::ERROR, static::QUERY_NOT_EXECUTED, static::NAME, $this->error( ), $this->message( ), $try, $this->sql( ) ) );
		}
		if ( is_object( $this->query( ) ) ) {
			$this->field_count( $this->query( )->field_count );
			while ( $field = $this->query( )->fetch_field( ) ) {
				$field->typeid = $field->type;
				switch ( $field->typeid ) {
					case MYSQLI_TYPE_CHAR:
					case MYSQLI_TYPE_STRING: 
					case MYSQLI_TYPE_VAR_STRING:
						$field->type = static::STRING; break; 
					case MYSQLI_TYPE_SHORT:
					case MYSQLI_TYPE_LONG:
					case MYSQLI_TYPE_LONGLONG:
					case MYSQLI_TYPE_INT24:
						$field->type = static::INT; break;
					case MYSQLI_TYPE_FLOAT:
					case MYSQLI_TYPE_DOUBLE:
					case MYSQLI_TYPE_DECIMAL:
					case MYSQLI_TYPE_NEWDECIMAL:
						$field->type = REAL;break;
					case MYSQLI_TYPE_TIMESTAMP:
						$field->type = static::TIMESTAMP; break;
					case MYSQLI_TYPE_YEAR:
					case MYSQLI_TYPE_DATE:
					case MYSQLI_TYPE_TIME:
					case MYSQLI_TYPE_DATETIME:
					case MYSQLI_TYPE_NEWDATE:
						$field->type = static::DATETIME; break;
					case MYSQLI_TYPE_TINY_BLOB:
					case MYSQLI_TYPE_MEDIUM_BLOB:
					case MYSQLI_TYPE_LONG_BLOB:
					case MYSQLI_TYPE_BLOB:
						$field->type = static::BLOB; break;
					case MYSQLI_TYPE_NULL:
					case MYSQLI_TYPE_INTERVAL:
					case MYSQLI_TYPE_SET:
					case MYSQLI_TYPE_GEOMETRY:
					case MYSQLI_TYPE_BIT:
					default:
						$field->type = static::OTHER;
				}
				$this->fields( NULL, $field );
			}
			$this->row_count( $this->query( )->num_rows );
			while ( $row = $this->query( )->fetch_array( ) ) {
				$this->rows( NULL, $row );
			}
			$this->query_info( sprintf( static::ROWS_SELECTED, $this->row_count( ) ) );
			$this->query( )->free( );
		} else {
			$this->query_info( $this->handler( )->info );
			$this->row_count( $this->handler( )->affected_rows );
			$this->insert_id( $this->handler( )->insert_id );
		}
		$this->duration( round( microtime( TRUE ) - $this->duration( ), static::DURATION_PRECISION ) );
		$this->durations( $this->durations( ) + $this->duration( ) );
		return $this->row_count( );
	}

	public function start_transaction() {
		return $this->handler( )->autocommit( FALSE );
	}

	public function commit( ) {
		$result = $this->handler( )->commit( );
		$this->handler( )->autocommit( TRUE );
		return $result;
	}

	public function rollback( ) {
		$result = $this->handler( )->rollback( );
		$this->handler( )->autocommit( TRUE );
		return $result;
	}
	
}

function mod_mysql() {
	return function_exists( 'mysql_connect' );
}

function mod_mysqli() {
	return class_exists( 'mysqli' );
}

function database( $object = NULL ) { 
	global $database;
	isset( $object ) && $database = $object;
	return $database;
}

$database = NULL;
