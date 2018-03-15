<?php

/*
 * MARS 4.0 PHP CODE
* build 4.0.0.0 @ 2016-09-11 00:00
* * rewritten from scratch
*/

require_once dirname( __FILE__ ) . '/os.php';

class omni extends cmd {
	const OMNI					= '$OMNI';
	const UX_PATH				= '$OMNI/bin';
	const WIN_PATH				= '$OMNI\\bin';
	const PREFIX				= 'omn';
	const CELLSERVER			= 'cellserver';
	const SESSIONID				= '\d+\/\d+\/\d+-\d+';
	const SPECIFICATION			= '(\w+ )?\S+';
	const STATUS				= '(\w+ )?\w+';
	const DATETIME				= '-|(\S+ \S+ \S+ \S+ \d+:\d+:\d+ ?(AM|PM)? ?\w+?)|(\d+\/\d+\/\d+ \d+:\d+:\d+ ?(AM|PM)?)';
	const HOSTNAME				= '\S+?(\.\S+?)*';
	const LABEL					= '\S+( \S+)?';
	const KB					= '\S+?( KB)?';
	const OBJECT				= '\S+?:\S+?( \'.+?\')?';
	private $home				= NULL;
	private $cellserver			= NULL;
	
	public function home( $value = NULL ) { return _var( $this->home, func_get_args( ) ); }
	public function cellserver( $value = NULL ) { return _var( $this->cellserver, func_get_args( ) ); }

	public static function command( $arguments = NULL ) {
		return str_replace( static::OMNI, is_object( omni( ) ) ? omni( )->home( ) : '', parent::command( $arguments ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		if ( is_object( omni( ) ) ) {
			is_null( omni( )->home( ) ) || $this->home( omni( )->home( ) );
			is_null( omni( )->tmp( ) ) || $this->tmp( omni( )->tmp( ) );
			is_null( omni( )->cellserver( ) ) || $this->cellserver( omni( )->cellserver( ) );
		}
		is_null( $this->cellserver( ) ) || $this->add_fields( omni::CELLSERVER, $this->cellserver( ) );
	}
}

### OMNIDBUTIL

class omnidbutil extends omni {
	const UX_BIN	= 'omnidbutil';
	const WIN_BIN	= 'omnidbutil';
}

class omnidbutil_show_cell_name extends omnidbutil {
	const ARGUMENTS = '-show_cell_name';
	const PATTERN = '^Catalog database owner: "%s"$';
	
	public static function pattern( ) {	return sprintf( static::PATTERN, text::P( omni::CELLSERVER ) );	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->cellserver( $row[ omni::CELLSERVER ] );
		omni( )->cellserver( $this->cellserver( ) );
	}
}

### OMNISV

class omnisv extends omni {
	const UX_BIN	= 'omnisv';
	const WIN_BIN	= 'omnisv';
}

class omnisv_version extends omnisv {
	const ARGUMENTS		= '-version';
	const PATTERN		= '^HP Data Protector %s: OMNISV, internal build %s, built on %s$';
	const VERSION 		= 'version';
	const BUILD 		= 'build';
	const TIMESTAMP		= 'timestamp';
	private $version	= NULL;
	private $build		= NULL;
	private $timestamp	= NULL;
	
	public function version( $value = NULL) { return _var( $this->version, func_get_args( ) ); }
	public function build( $value = NULL) { return _var( $this->build, func_get_args( ) ); }
	public function timestamp( $value = NULL) { return _var( $this->timestamp, func_get_args( ) ); }
	
	public static function pattern( ) {
		return sprintf( static::PATTERN, 
			text::P( static::VERSION ), text::P( static::BUILD ), text::P( static::TIMESTAMP, omni::DATETIME ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->fields( static::TIMESTAMP, field::DATETIME );
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) { 
			$this->version( $row[ static::VERSION ] ); 
			$this->build( $row[ static::BUILD ] ); 
			$this->timestamp( $row[ static::TIMESTAMP ] ); 
		}
	}
}

class omnisv_status extends omnisv {
	const ARGUMENTS		= '-status';
	const PATTERN		= '^\s*%s\s*: %s(\s+\[%s\]| \(CMMDB is on %s\))?$';
	const NAME 			= 'name';
	const STATUS 		= 'status';
	const PID 			= 'PID';
	const CMMDB 		= 'CMMDB';
	private $services	= array( );
	private $status		= NULL;
	
	public function services( $field = NULL, $value = NULL) { return _arr( $this->services, func_get_args( ) ); }
	public function status( $value = NULL) { return _var( $this->status, func_get_args( ) ); }
	
	public static function pattern( ) {
		return sprintf( static::PATTERN, 
			text::P( static::NAME ), text::P( static::STATUS, text::ALL ), text::P( static::PID ), text::P( static::CMMDB ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, '^=+' );
		$this->ignore_lines( NULL, 'ProcName' );
		$this->ignore_lines( NULL, 'Sending of traps' );
	}
	
	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) {
			if ( $row[ static::NAME ] == 'Status' ) {
				$this->status( $row[ static::STATUS ] );
				continue;
			}
			if ( empty( $row[ static::CMMDB ] ) ) unset( $row[ static::CMMDB ] );
			$this->services( $row[ static::NAME ], $row ); 
		}
	}
}

### OMNISTAT

class omnistat extends omni {
	const UX_BIN	= 'omnistat';
	const WIN_BIN	= 'omnistat';
	const SESSIONID	= 'sessionid';
	const TYPE		= 'type';
	const STATUS	= 'status';
	const OWNER		= 'owner';
	private $sessions = array( );
	
	public function sessions( $field = NULL, $value = NULL) { return _arr( $this->sessions, func_get_args( ) ); }

	public static function pattern( ) {
		$pattern = array( 
			text::P( static::SESSIONID, omni::SESSIONID ), 
			text::P( static::TYPE ),
			text::P( static::STATUS, omni::STATUS ), 
			text::P( static::OWNER ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, '^=+' );
		$this->ignore_lines( NULL, '^No currently running sessions.' );
		$this->ignore_lines( NULL, '^Session ?ID\s+Type' );
	}
	
	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->sessions( $row[ static::SESSIONID ], $row );
	}
}

class omnistat_previous extends omnistat {
	const ARGUMENTS = '-previous';
}

class omnistat_previous_last extends omnistat {
	const ARGUMENTS = '-previous -last %s';
}

class omnistat_detail extends omnistat {
	const ARGUMENTS 	= '-detail';
	const STARTED		= 'started';
	const SPECIFICATION	= 'specification';
	
	public static function pattern( ) {
		$pattern = array( 
			sprintf( 'SessionID : %s', text::P( static::SESSIONID, omni::SESSIONID ) ),
			sprintf( 'Session type\s+: %s', text::P( static::TYPE ) ),
			sprintf( 'Session status\s+: %s', text::P( static::STATUS, omni::STATUS ) ),
			sprintf( 'User\.Group@Host\s+: %s', text::P( static::OWNER ) ),
			sprintf( 'Session started\s+: %s', text::P( static::STARTED, omni::DATETIME ) ),
			sprintf( 'Backup Specification: %s', text::P( static::SPECIFICATION, omni::SPECIFICATION ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( text::DOUBLE_NEW_LINE );
		$this->fields( static::STARTED, field::DATETIME );
	}
}

class omnistat_session extends omnistat {
	const ARGUMENTS		= '-session %s';
	const DEVICE		= 'device';
	const HOST			= 'host';
	const DONE			= 'done';
	const STATUS		= 'status';
	const OBJECT		= 'object';
	const TYPE			= 'type';
	const RUNLEVEL		= 'runlevel';
	const TOTAL			= 'total';
	private $sessionid	= NULL;
	private $_devices	= NULL;
	private $_objects	= NULL;
	private $devices	= array( );
	private $objects	= array( );
	
	public function sessionid( $value = NULL ) { return _var( $this->sessionid, func_get_args( ) ); }
	public function _devices( $value = NULL ) { return _var( $this->_devices, func_get_args( ) ); }
	public function _objects( $value = NULL ) { return _var( $this->_objects, func_get_args( ) ); }
	public function devices( $field = NULL, $value = NULL) { return _arr( $this->devices, func_get_args( ) ); }
	public function objects( $field = NULL, $value = NULL) { return _arr( $this->objects, func_get_args( ) ); }
	
	protected function setup( ) {
		$this->sessionid( $this->arguments( ) );
		parent::setup( );
		$this->add_fields( static::SESSIONID, $this->sessionid( ) );
		$this->ignore_lines( NULL, '^Device\s+Host' );
		$this->ignore_lines( NULL, '^ObjectName\s+ObjectType' );
	}
	
	protected function parse_rows( ) {
		$this->_devices( new omnistat_session_devices( $this->sessionid( ) ) )->parse( $this->lines( ) );
		$this->_objects( new omnistat_session_objects( $this->sessionid( ) ) )->parse( $this->lines( ) );
		$this->parsing_errors( array_unique( array_merge( 
			$this->_devices( )->parsing_errors( ), 
			$this->_objects( )->parsing_errors( ) ) ) );
		$this->devices( $this->_devices( )->devices( ) );
		$this->objects( $this->_objects( )->objects( ) );
	}

	public function sql( $table = NULL ) {
		$result = array( $this->_devices( )->sql( $table ), $this->_objects( )->sql( $table) ); 
		return array_filter( $result );
	}
}

class omnistat_session_devices extends omnistat_session {
	private  $devices = array( );
	
	public function devices( $field = NULL, $value = NULL) { return _arr( $this->devices, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			text::P( static::DEVICE ), 
			text::P( static::HOST ), 
			text::P( static::DONE, omni::KB ),	
			text::P( static::STATUS ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, omnistat_session_objects::pattern( ) );
		$this->fields( static::DONE, field::INTEGER );
	}
	
	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->devices( $row[ static::DEVICE ], $row );
	}

	public function sql( $table = NULL ) {
		return omni::sql( $table );
	}
}

class omnistat_session_objects extends omnistat_session {
	private $objects = array( );
	
	public function objects( $field = NULL, $value = NULL) { return _arr( $this->objects, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			text::P( static::OBJECT ), 
			text::P( static::TYPE ), 
			text::P( static::RUNLEVEL ), 
			text::P( static::TOTAL, omni::KB ), 
			text::P( static::DONE, omni::KB ), 
			text::P( static::STATUS ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, omnistat_session_devices::pattern( ) );
		$this->fields( static::DONE, field::INTEGER );
		$this->fields( static::TOTAL, field::INTEGER );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->objects( NULL, $row );
	}

	public function sql( $table = NULL ) {
		return omni::sql( $table );
	}
}

class omnistat_session_detail extends omnistat_session {
	const ARGUMENTS 		= '-session %s -detail';
	const STARTED			= 'started';
	const FINISHED			= 'finished';
	const PHYSICALDEVICE	= 'physicaldevice';
	const DESCRIPTION		= 'description';

	protected function parse_rows( ) {
		$this->_devices( new omnistat_session_detail_devices( $this->sessionid( ) ) )->parse( $this->lines( ) );
		$this->_objects( new omnistat_session_detail_objects( $this->sessionid( ) ) )->parse( $this->lines( ) );
		$this->parsing_errors( array_unique( array_merge( 
			$this->_devices( )->parsing_errors( ), 
			$this->_objects( )->parsing_errors( ) ) ) );
		$this->devices( $this->_devices( )->devices( ) );
		$this->objects( $this->_objects( )->objects( ) );
	}
}

class omnistat_session_detail_devices extends omnistat_session_detail {
	private $devices = array( );
	
	public function devices( $field = NULL, $value = NULL) { return _arr( $this->devices, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			sprintf( 'Device name\s+: %s', text::P( static::DEVICE ) ),
			sprintf( 'Host\s+: %s', text::P( static::HOST ) ),
			sprintf( 'Started\s+: %s', text::P( static::STARTED, omni::DATETIME ) ),
			sprintf( 'Finished\s+: %s', text::P( static::FINISHED, omni::DATETIME ) ),
			sprintf( 'Done\s+: %s', text::P( static::DONE, omni::KB ) ),
			sprintf( 'Physical device\s+:( %s)?', text::P( static::PHYSICALDEVICE ) ),
			sprintf( 'Status\s+: %s', text::P( static::STATUS ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( text::DOUBLE_NEW_LINE );
		$this->ignore_lines( NULL, omnistat_session_detail_objects::pattern( ) );
		$this->fields( static::STARTED, field::DATETIME );
		$this->fields( static::FINISHED, field::DATETIME );
		$this->fields( static::DONE, field::INTEGER );
	}
	
	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->devices( $row[ static::DEVICE ], $row );
	}

	public function sql( $table = NULL ) {
		return omni::sql( $table );
	}
}

class omnistat_session_detail_objects extends omnistat_session_detail {
	private $objects = array( );
	const RUNLEVEL			= 'runlevel';
	const WARNINGS			= 'warnings';
	const ERRORS			= 'errors';
	const TOTALFILES		= 'totalfiles';
	const PROCESSEDFILES	= 'processedfiles';
	const TOTALSIZE			= 'totalsize';
	const PROCESSEDSIZE		= 'processedsize';
	
	public function objects( $field = NULL, $value = NULL) { return _arr( $this->objects, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array(
			sprintf( 'Object name\s+: %s:%s( \'%s\')?' , 
				text::P( static::HOST ), text::P( static::OBJECT ), text::P( static::DESCRIPTION, text::ALL ) ),
			sprintf( 'Type\s+: %s', text::P( static::TYPE ) ),
			sprintf( 'Started\s+: %s', text::P( static::STARTED, omni::DATETIME ) ),
			sprintf( 'Finished\s+: %s', text::P( static::FINISHED, omni::DATETIME ) ),
			sprintf( 'RunLevel\s+: %s', text::P( static::RUNLEVEL ) ),
			sprintf( 'Warnings\s+: %s', text::P( static::WARNINGS ) ),
			sprintf( 'Errors\s+: %s', text::P( static::ERRORS ) ),
			sprintf( 'Total files\s+: %s', text::P( static::TOTALFILES ) ),
			sprintf( 'Processed files\s+: %s', text::P( static::PROCESSEDFILES ) ),
			sprintf( 'Total size\s+: %s', text::P( static::TOTALSIZE, omni::KB ) ),
			sprintf( 'Processed size\s+: %s', text::P( static::PROCESSEDSIZE, omni::KB ) ),
			sprintf( 'Device\s+:( %s)?', text::P( static::DEVICE ) ),
			sprintf( 'Status\s+: %s', text::P( static::STATUS ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( text::DOUBLE_NEW_LINE );
		$this->ignore_lines( NULL, omnistat_session_detail_devices::pattern( ) );
		$this->fields( static::STARTED, field::DATETIME );
		$this->fields( static::FINISHED, field::DATETIME );
		$this->fields( static::WARNINGS, field::INTEGER );
		$this->fields( static::ERRORS, field::INTEGER );
		$this->fields( static::TOTALFILES, field::INTEGER );
		$this->fields( static::PROCESSEDFILES, field::INTEGER );
		$this->fields( static::TOTALSIZE, field::INTEGER );
		$this->fields( static::PROCESSEDSIZE, field::INTEGER );
	}
	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->objects( sprintf( '%s:%s', $row[ static::HOST ], $row[ static::OBJECT ] ), $row );
	}

	public function sql( $table = NULL ) {
		return omni::sql( $table );
	}
}

### OMNIDB

class omnidb extends omni {
	const UX_BIN			= 'omnidb';
	const WIN_BIN			= 'omnidb';
	private $sessionid		= NULL;
	
	public function sessionid( $value = NULL ) { return _var( $this->sessionid, func_get_args( ) ); }
	
	protected function setup( ) {
		$this->sessionid( $this->arguments( ) );
		parent::setup( );
		$this->add_fields( 'sessionid', $this->sessionid( ) );
		$this->ignore_lines( NULL, '^=+' );
	}
}

class omnidb_rpt extends omnidb {
	const ARGUMENTS		= '-rpt %s';
	private $session	= array( );
	
	public function session( $field = NULL, $value = NULL ) { return _arr( $this->session, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			text::P( 'sessionid', omni::SESSIONID ), 
			text::P( 'specification', omni::SPECIFICATION ),
			text::P( 'status', omni::STATUS ), 
			text::P( 'starttime' ), 
			text::P( 'duration' ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( text::DOUBLE_NEW_LINE );
		$this->ignore_lines( NULL, '^No objects within session .+ have been found.' );
		$this->fields( 'starttime', field::TIME );
		$this->fields( 'duration', field::REAL );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->session( $row );
	}
}

class omnidb_rpt_detail extends omnidb_rpt {
	const ARGUMENTS = '-rpt %s -detail';

	public static function pattern( ) {
		$pattern = array( 
			sprintf( 'SessionID : %s', text::P( 'sessionid', omni::SESSIONID ) ),
			sprintf( 'Backup Specification:( %s)?', text::P( 'specification', omni::SPECIFICATION ) ),
			sprintf( 'Session type\s+: %s', text::P( 'type' ) ),
			sprintf( 'Started\s+: %s', text::P( 'started', omni::DATETIME ) ),
			sprintf( 'Finished\s+: %s', text::P( 'finished', omni::DATETIME ) ),
			sprintf( 'Status\s+: %s', text::P( 'status', omni::STATUS ) ),
			sprintf( 'Number of warnings\s+: %s', text::P( 'warnings' ) ),
			sprintf( 'Number of errors\s+: %s', text::P( 'errors' ) ),
			sprintf( 'User\s+: %s', text::P( 'user' ) ),
			sprintf( 'Group\s+: %s', text::P( 'group' ) ),
			sprintf( 'Host\s+: %s', text::P( 'host' ) ),
			sprintf( 'Session data size \[kB\]: %s', text::P( 'kb', omni::KB ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( text::DOUBLE_NEW_LINE );
		$this->fields( 'started', field::DATETIME );
		$this->fields( 'finished', field::DATETIME );
		$this->fields( 'warnings', field::INTEGER );
		$this->fields( 'errors', field::INTEGER );
		$this->fields( 'kb', field::INTEGER );
	}
}

class omnidb_session extends omnidb {
	const ARGUMENTS	= '-session %s';
	private $objects	= array( );
	
	public function objects( $field = NULL, $value = NULL ) { return _arr( $this->objects, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array(
			sprintf( '%s:%s( \'%s\')?' , text::P( 'host' ), text::P( 'object' ), text::P( 'description', text::ALL ) ),
			text::P( 'type' ),
			text::P( 'status' ),
			text::P( 'copyid', text::ALL ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
		
	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, '^Object Name' );
		$this->ignore_lines( NULL, '^No objects within session .+ have been found.' );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->objects( sprintf( '%s:%s' , $row[ 'host' ], $row[ 'object' ] ), $row );
	}
}

class omnidb_session_detail extends omnidb_session {
	const ARGUMENTS = '-session %s -detail';

	public static function pattern( ) {
		$pattern = array(
			sprintf( 'Object name\s+: %s:%s( \'%s\')?', text::P( 'host' ), text::P( 'object' ), text::P( 'description', text::ALL ) ),
			sprintf( 'Object type\s+: %s', text::P( 'type' ) ),
			sprintf( 'Object status\s+: %s', text::P( 'status' ) ),
			sprintf( 'Started\s+: %s', text::P( 'started', omni::DATETIME ) ),
			sprintf( 'Finished\s+: %s', text::P( 'finished', omni::DATETIME ) ),
			sprintf( 'Object size\s+: %s', text::P( 'size', omni::KB ) ),
			sprintf( 'Backup type\s+: %s', text::P( 'mode' ) ),
			sprintf( 'Protection\s+: %s', text::P( 'protection', text::ALL ) ),
			sprintf( 'Catalog retention\s+: %s', text::P( 'retention', text::ALL ) ),
			sprintf( 'Version type\s+: %s', text::P( 'version' ) ),
			sprintf( 'Access\s+: %s', text::P( 'access' ) ),
			sprintf( 'Number of warnings\s+: %s', text::P( 'warnings' ) ),
			sprintf( 'Number of errors\s+: %s', text::P( 'errors' ) ),
			sprintf( 'Device name\s+: %s', text::P( 'device' ) ),
			sprintf( 'Backup ID\s+: %s', text::P( 'backupid' ) ),
			sprintf( 'Copy ID\s+: %s', text::P( 'copyid', text::ALL ) ),
			sprintf( 'Encrypted\s+: %s', text::P( 'encrypted' ) ),
			sprintf( 'DiskAgent ID\s+: %s', text::P( 'diskagentid' ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( text::DOUBLE_NEW_LINE );
		$this->fields( 'started', field::DATETIME );
		$this->fields( 'finished', field::DATETIME );
		$this->fields( 'size', field::INTEGER );
		$this->fields( 'warnings', field::INTEGER );
		$this->fields( 'errors', field::INTEGER );
		$this->fields( 'diskagentid', field::INTEGER );
	}
}

class omnidb_session_media extends omnidb {
	const ARGUMENTS	= '-session %s -media';
	private $media	= array( );
	
	public function media( $field = NULL, $value = NULL ) { return _arr( $this->media, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			text::P( 'label', omni::LABEL ), 
			text::P( 'mediumid' ), 
			text::P( 'freeblocks' ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, '^Medium Label' );
		$this->ignore_lines( NULL, '^No media found.' );
		$this->fields( 'freeblocks', field::INTEGER );
	}
	
	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->media( $row[ 'mediumid' ], $row );
	}
}

class omnidb_session_media_detail extends omnidb_session_media {
	const ARGUMENTS = '-session %s -media -detail';

	public static function pattern( ) {
		$pattern = array(
			sprintf( 'MediumID : %s', text::P( 'mediumid' ) ),
			sprintf( 'Medium Label\s+: %s', text::P( 'label',omni::LABEL ) ),
			sprintf( 'Location\s+: %s', text::P( 'location', text::ALL ) ),
			sprintf( 'Used blocks \[KB\]\s+: %s', text::P( 'usedblocks' ) ),
			sprintf( 'Total blocks \[KB\]\s+: %s', text::P( 'totalblocks' ) ),
			sprintf( 'Number of writes\s+: %s', text::P( 'writes' ) ),
			sprintf( 'Number of overwrites\s+: %s', text::P( 'overwrites' ) ),
			sprintf( 'Number of errors\s+: %s', text::P( 'errors' ) ),
			sprintf( 'Creation time\s+: %s', text::P( 'created', omni::DATETIME ) ),
			sprintf( 'Time of last write\s+: %s', text::P( 'lastwrite', omni::DATETIME ) ),
			sprintf( 'Time of last overwrite\s+: %s', text::P( 'lastoverwrite', omni::DATETIME ) ),
			sprintf( 'Time of last access\s+: %s', text::P( 'lastaccess', omni::DATETIME ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		omni::setup( );
		$this->row_delimiter( static::DOUBLE_NEW_LINE );
		$this->fields( 'usedblocks', field::INTEGER );
		$this->fields( 'totalblocks', field::INTEGER );
		$this->fields( 'writes', field::INTEGER );
		$this->fields( 'overwrites', field::INTEGER );
		$this->fields( 'errors', field::INTEGER );
		$this->fields( 'created', field::DATETIME );
		$this->fields( 'lastwrite', field::DATETIME );
		$this->fields( 'lastoverwrite', field::DATETIME );
		$this->fields( 'lastaccess', field::DATETIME );
	}
}

class omnidb_session_report extends omnidb {
	const ARGUMENTS = '-session %s -report';
	private $errors = array( );
	
	public function errors( $field = NULL, $value = NULL ) { return _arr( $this->errors, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array(
			sprintf( '\[%s\]', text::P( 'severity' ) ),
			sprintf( 'From: %s', text::P( 'from' ) ),
			sprintf( '\"%s\"', text::P( 'description' ) ),
			sprintf( 'Time: %s', text::P( 'timestamp', omni::DATETIME ) ),
			sprintf( '\[%s\]', text::P( 'error' ) ),
			sprintf( '(%s\r?\n)?', text::P( 'source' ) ),
			sprintf( '%s', text::P( 'message', text::TEXT ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( static::DOUBLE_NEW_LINE );
		$this->fields( 'timestamp', field::DATETIME );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->errors( NULL, $row );
	}
}

### OMNIRPT

class omnirpt extends omni {
	const UX_BIN		= 'omnirpt';
	const WIN_BIN		= 'omnirpt';
	
	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, '^#' );
	}
}

class omnirpt_session extends omnirpt {
	private $sessionid	= NULL;

	public function sessionid( $value = NULL ) { return _var( $this->sessionid, func_get_args( ) ); }

	protected function setup( ) {
		$this->sessionid( $this->arguments( ) );
		parent::setup( );
		$this->add_fields( 'sessionid', $this->sessionid( ) );
		$this->ignore_lines( NULL, '^Error creating the report "Interactive":.+$' );
		$this->ignore_lines( NULL, '^Session not found.$' );
	}
}

class omnirpt_single_session extends omnirpt_session {
	const ARGUMENTS 	= '-report single_session -session %s';
	private $_session	= NULL;
	private $_objects	= NULL;
	private $_errors	= NULL;
	private $session	= array( );
	private $objects	= array( );
	private $errors		= array( );
	
	public function _session( $value = NULL ) { return _var( $this->_session, func_get_args( ) ); }
	public function _objects( $value = NULL ) { return _var( $this->_objects, func_get_args( ) ); }
	public function _errors( $value = NULL ) { return _var( $this->_errors, func_get_args( ) ); }
	public function session( $field = NULL, $value = NULL ) { return _arr( $this->session, func_get_args( ) ); }
	public function objects( $field = NULL, $value = NULL ) { return _arr( $this->objects, func_get_args( ) ); }
	public function errors( $field = NULL, $value = NULL ) { return _arr( $this->errors, func_get_args( ) ); }
	
	protected function parse_rows( ) {
		$this->_session( new omnirpt_single_session_session( $this->sessionid( ) ) )->parse( $this->lines( ) );
		$this->_objects( new omnirpt_single_session_failed_objects( $this->sessionid( ) ) )->parse( $this->lines( ) );
		$this->_errors( new omnirpt_single_session_errors( $this->sessionid( ) ) )->parse( $this->lines( ) );
		$this->parsing_errors( array_unique( array_merge( 
			$this->_session( )->parsing_errors( ), 
			$this->_objects( )->parsing_errors( ), 
			$this->_errors( )->parsing_errors( ) ) ) );
		$this->session( $this->_session( )->session( ) );
		$this->objects( $this->_objects( )->objects( ) );
		$this->errors( $this->_errors( )->errors( ) );
	}

	public function sql( $table = NULL ) {
		$result = array( $this->_session( )->sql( $table ), $this->_objects( )->sql( $table), $this->_errors( )->sql( $table));
		return array_filter( $result );
	}
}

class omnirpt_single_session_session extends omnirpt_single_session {
	private $session = array( );
	
	public function session( $field = NULL, $value = NULL ) { return _arr( $this->session, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			static::P( 'specification', static::SPECIFICATION ), 
			static::P( 'sessionid', static::SESSIONID ), 
			static::P( 'type' ),
			static::P( 'owner' ), 
			static::P( 'status', static::STATUS ), 
			static::P( 'mode' ), 
			static::P( 'starttime', static::DATETIME ),
			static::P( 'starttimet' ), 
			static::P( 'endtime', static::DATETIME ), 
			static::P( 'endtimet' ), 
			static::P( 'queuing' ),
			static::P( 'duration' ), 
			static::P( 'gbwritten' ), 
			static::P( 'media' ), 
			static::P( 'errors' ),
			static::P( 'warnings' ), 
			static::P( 'pendingda' ), 
			static::P( 'runningda' ), 
			static::P( 'failedda' ),
			static::P( 'completedda' ), 
			static::P( 'objects' ), 
			static::P( 'success' ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, omnirpt_single_session_failed_objects::pattern( ) );
		$this->ignore_lines( NULL, omnirpt_single_session_errors::pattern( ) );
		$this->fields( 'starttime', field::DATETIME );
		$this->fields( 'endtime', field::DATETIME );
		$this->fields( 'timestamp', field::DATETIME );
		$this->fields( 'queuing', field::TIME );
		$this->fields( 'duration', field::TIME );
		$this->fields( 'starttimet', field::INTEGER );
		$this->fields( 'endtimet', field::INTEGER );
		$this->fields( 'media', field::INTEGER );
		$this->fields( 'errors', field::INTEGER );
		$this->fields( 'warnings', field::INTEGER );
		$this->fields( 'pendingda', field::INTEGER );
		$this->fields( 'runningda', field::INTEGER );
		$this->fields( 'failedda', field::INTEGER );
		$this->fields( 'completedda', field::INTEGER );
		$this->fields( 'objects', field::INTEGER );
		$this->fields( 'gbwritten', field::REAL );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->session( $row );
	}

	public function sql( $table = NULL ) {
		return omni::sql( $table);
	}
}

class omnirpt_single_session_failed_objects extends omnirpt_single_session {
	private $objects = array( );
	
	public function objects( $field = NULL, $value = NULL ) { return _arr( $this->objects, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array(
			static::P( 'type' ),
			static::P( 'client' ),
			static::P( 'mountpoint' ),
			static::P( 'description' ),
			static::P( 'status' ),
			static::P( 'errors' ),
			static::P( 'warnings' ),
			static::P( 'device' ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
		
	protected function setup( ) {
		omnirpt::setup( );
		$this->ignore_lines( NULL, omnirpt_single_session::pattern( ) );
		$this->ignore_lines( NULL, omnirpt_single_session_errors::pattern( ) );
		$this->fields( 'errors', field::INTEGER );
		$this->fields( 'warnings', field::INTEGER );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->objects( sprintf( '%s:%s' , $row[ 'client' ], $row[ 'object' ] ), $row );
	}

	public function sql( $table = NULL ) {
		return omni::sql( $table);
	}
}

class omnirpt_single_session_errors extends omnirpt_single_session {
	private $errors = array( );
	
	public function errors( $field = NULL, $value = NULL ) { return _arr( $this->errors, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array(
			sprintf( '\[%s\]', text::P( 'severity' ) ),
			sprintf( 'From: %s', text::P( 'from' ) ),
			sprintf( '\"%s\"', text::P( 'description' ) ),
			sprintf( 'Time: %s', text::P( 'timestamp', omni::DATETIME ) ),
			sprintf( '\[%s\]', text::P( 'error' ) ),
			sprintf( '(%s\r?\n)?', text::P( 'source' ) ),
			sprintf( '%s', text::P( 'message', text::TEXT ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		omnirpt::setup( );
		$this->ignore_lines( NULL, omnirpt_single_session::pattern( ) );
		$this->ignore_lines( NULL, omnirpt_single_session_failed_objects::pattern( ) );
		$this->fields( 'timestamp', field::DATETIME );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->errors( NULL, $row );
	}

	public function sql( $table = NULL ) {
		return omni::sql( $table );
	}
}

class omnirpt_session_devices extends omnirpt_session {
	const ARGUMENTS		= '-report session_devices -session %s';
	private $devices	= array( );
	
	public function devices( $field = NULL, $value = NULL ) { return _arr( $this->devices, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			text::P( 'device' ),
			text::P( 'start', omni::DATETIME ),
			text::P( 'start_t' ),
			text::P( 'end', omni::DATETIME ),
			text::P( 'end_t' ),
			text::P( 'duration' ),
			text::P( 'gbwritten' ),
			text::P( 'perf' ),
			text::P( 'objects' ),
			text::P( 'media' ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
		
	protected function setup( ) {
		parent::setup( );
		$this->fields( 'start', field::DATETIME );
		$this->fields( 'end', field::DATETIME );
		$this->fields( 'duration', field::TIME );
		$this->fields( 'start_t', field::INTEGER );
		$this->fields( 'end_t', field::INTEGER );
		$this->fields( 'objects', field::INTEGER );
		$this->fields( 'media', field::INTEGER );
		$this->fields( 'gbwritten', field::REAL );
		$this->fields( 'perf', field::REAL );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->devices( $row[ 'device' ], $row );
	}
}

class omnirpt_session_objects extends omnirpt_session {
	const ARGUMENTS		= '-report session_objects -session %s';
	private $objects	= array( );

	public function objects( $field = NULL, $value = NULL ) { return _arr( $this->objects, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			text::P( 'type' ), 
			text::P( 'client', omni::HOSTNAME ), 
			text::P( 'mountpoint' ),
			text::P( 'description' ), 
			text::P( 'status', omni::STATUS ), 
			text::P( 'mode' ),
			text::P( 'starttime', omni::DATETIME ), 
			text::P( 'starttimet' ),
			text::P( 'endtime', omni::DATETIME ), 
			text::P( 'endtimet' ), 
			text::P( 'duration' ),
			text::P( 'size' ), 
			text::P( 'files' ), 
			text::P( 'performance' ), 
			text::P( 'protection', omni::DATETIME ),
			text::P( 'errors' ), 
			text::P( 'warnings' ), 
			text::P( 'device' ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	protected function setup( ) {
		parent::setup( );
		$this->fields( 'starttime', field::DATETIME );
		$this->fields( 'endtime', field::DATETIME );
		$this->fields( 'protection', field::DATETIME );
		$this->fields( 'duration', field::TIME );
		$this->fields( 'starttimet', field::INTEGER );
		$this->fields( 'endtimet', field::INTEGER );
		$this->fields( 'size', field::INTEGER );
		$this->fields( 'files', field::INTEGER );
		$this->fields( 'errors', field::INTEGER );
		$this->fields( 'warnings', field::INTEGER );
		$this->fields( 'performance', field::REAL );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->objects( sprintf( '%s:%s' , $row[ 'client' ], $row[ 'mountpoint' ] ), $row );
	}
}

class omnirpt_session_media extends omnirpt_session {
	const ARGUMENTS	= '-report session_media -session %s';
	private $media	= array( );
	
	public function media( $field = NULL, $value = NULL ) { return _arr( $this->media, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array( 
			text::P( 'mediumid' ), 
			text::P( 'label', omni::LABEL ), 
			text::P( 'location', text::ALL ),
			text::P( 'pool' ), 
			text::P( 'protection', omni::DATETIME ), 
			text::P( 'used' ),
			text::P( 'total' ), 
			text::P( 'last_used', omni::DATETIME ), 
			text::P( 'last_usedt' ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->fields( 'protection', field::DATETIME );
		$this->fields( 'last_used', field::DATETIME );
		$this->fields( 'duration', field::TIME );
		$this->fields( 'last_usedt', field::INTEGER );
		$this->fields( 'used', field::REAL );
		$this->fields( 'total', field::REAL );
	}

	protected function parse_rows( ) {
		omni::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->objects( $row[ 'mediumid' ], $row );
	}
}

function omni( ) { global $omni; return $omni; }
function omnidbutil_show_cell_name( ) { return new omnidbutil_show_cell_name( ); }
function omnisv_version( ) { return new omnisv_version( ); }
function omnisv_status( ) { return new omnisv_status( ); }
function omnistat( ) { return new omnistat( ); }
function omnistat_detail( ) { return new omnistat_detail( ); }
function omnistat_previous( ) { return new omnistat_previous( ); }
function omnistat_previous_last( $days = 1 ) { return new omnistat_previous_last( $days ); }
function omnistat_session( $sessionid ) { return new omnistat_session( $sessionid ); }
function omnistat_session_detail( $sessionid ) { return new omnistat_session_detail( $sessionid ); }
function omnidb_rpt( $sessionid ) { return new omnidb_rpt( $sessionid ); }
function omnidb_rpt_detail( $sessionid ) { return new omnidb_rpt_detail( $sessionid ); }
function omnidb_session( $sessionid ) { return new omnidb_session( $sessionid ); }
function omnidb_session_detail( $sessionid ) { return new omnidb_session_detail( $sessionid ); }
function omnidb_session_media( $sessionid ) { return new omnidb_session_media( $sessionid ); }
function omnidb_session_media_detail( $sessionid ) { return new omnidb_session_media_detail( $sessionid ); }
function omnidb_session_report( $sessionid ) { return new omnidb_session_report( $sessionid ); }
function omnirpt_single_session( $sessionid ) { return new omnirpt_single_session( $sessionid ); }
function omnirpt_session_objects( $sessionid ) { return new omnirpt_session_objects( $sessionid ); }
function omnirpt_session_devices( $sessionid ) { return new omnirpt_session_devices( $sessionid ); }
function omnirpt_session_media( $sessionid ) { return new omnirpt_session_media( $sessionid ); }

function servername( ) { 
	$object = new omnidbutil_show_cell_name( ); 
	$name = $object->cellserver( ); 
	unset( $object ); 
	return $name;
}

function version( ) { return new omnisv_version( ); }
function status( ) { return new omnisv_status( ); }
function running_sessions( ) { return new omnistat_detail( ); }
function running_session( $sessionid ) { return new omnistat_session_detail( $sessionid ); }
function sessions( $days = 1 ) { return new omnistat_previous_last( $days ); }
function db_session( $sessionid ) { return new omnidb_rpt_detail( $sessionid ); }
function db_objects( $sessionid ) { return new omnidb_session_detail( $sessionid ); }
function db_media( $sessionid ) { return new omnidb_session_media_detail( $sessionid ); }
function db_errors( $sessionid ) { return new omnidb_session_report( $sessionid ); }
function session( $sessionid ) { return new omnirpt_single_session( $sessionid ); }
function objects( $sessionid ) { return new omnirpt_session_objects( $sessionid ); }
function devices( $sessionid ) { return new omnirpt_session_devices( $sessionid ); }
function media( $sessionid ) { return new omnirpt_session_media( $sessionid ); }

$omni = new omni( );
