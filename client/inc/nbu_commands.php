<?php

/*
 * MARS 4.1 PHP CODE
 * build 4.1.19 @ 2019-11-06 04:01:19
 * * rewritten from scratch
 */

require_once implode( DIRECTORY_SEPARATOR, array( __DIR__, 'os.php' ) );

class nbu extends cmd {
	const NBU					= '$NBU';
	const WIN_PATH				= '$NBU\\NetBackup\\bin';
	const PREFIX				= 'nbu';
	const MASTERSERVER			= 'masterserver';
	const HOSTNAME				= '\S+?(\.\S+?)*';
	private $home				= NULL;
	private $masterserver		= NULL;

	public function home( $value = NULL ) { return _var( $this->home, func_get_args( ) ); }
	public function masterserver( $value = NULL ) { return _var( $this->masterserver, func_get_args( ) ); }

	public static function command( $arguments = NULL ) {
		return str_replace( static::NBU, is_object( nbu( ) ) ? nbu( )->home( ) : '', parent::command( $arguments ) );
	}

	protected function setup( ) {
		parent::setup( );
		if ( is_object( nbu( ) ) ) {
			is_null( nbu( )->home( ) ) || $this->home( nbu( )->home( ) );
			is_null( nbu( )->tmp( ) ) || $this->tmp( nbu( )->tmp( ) );
			is_null( nbu( )->masterserver( ) ) || $this->masterserver( nbu( )->masterserver( ) );
		}
		is_null( $this->masterserver( ) ) || $this->add_fields( nbu::MASTERSERVER, $this->masterserver( ) );
	}
	
}

### NBSTL

class nbstl extends nbu {
	const WIN_BIN				= 'admincmd\\nbstl';
	const ARGUMENTS				= '-l';
	const SLPNAME				= 'slpname';
	const DATACLASSIFICATION	= 'dataclassification';
	const DUPLICATIONPRIORITY	= 'duplicationpriority';
	const STATE					= 'state';
	const VERSION				= 'version';
	const USEFOR				= 'usefor';
	const STORAGEUNIT			= 'storageunit';
	const VOLUMEPOOL			= 'volumepool';
	const MEDIAOWNER			= 'mediaowner';
	const RETENTIONTYPE			= 'retentiontype';
	const RETENTIONLEVEL		= 'retentionlevel';
	const ALTERNATEREADSERVER	= 'alternatereadserver';
	const PRESERVEMPX			= 'preservempx';
	const DDOSTATE				= 'ddostate';
	const SOURCE				= 'source';
	const UNUSED				= 'unused';
	const OPERATIONID			= 'operationid';
	const OPERATIONINDEX		= 'operationindex';
	const SLPWINDOW				= 'slpwindow';
	const TARGETMASTER			= 'targetmaster';
	const TARGETMASTERSLP		= 'targetmasterslp';
	const UPDATED				= 'updated';
	const OBSOLETED				= 'obsoleted';

	private $updated			= '';
	private $slps				= array( );
	private $slps_row			= array( );
	
	public function updated( $value = NULL ) { return _var( $this->updated, func_get_args( ) ); }
	public function slps( $field = NULL, $value = NULL) { return _arr( $this->slps, func_get_args( ) ); }
	public function slps_row( $field = NULL, $value = NULL) { return _arr( $this->slps_row, func_get_args( ) ); }

	public static function pattern( ) {
		$pattern = array(
			text::P( static::SLPNAME, text::CSV ),
			text::P( static::DATACLASSIFICATION, text::CSV ),
			text::P( static::DUPLICATIONPRIORITY, text::CSV ),
			text::P( static::STATE, text::CSV ),
			text::P( static::VERSION, text::CSV ),
			text::P( static::USEFOR, text::CSV ),
			text::P( static::STORAGEUNIT, text::CSV ),
			text::P( static::VOLUMEPOOL, text::CSV ),
			text::P( static::MEDIAOWNER, text::CSV ),
			text::P( static::RETENTIONTYPE, text::CSV ),
			text::P( static::RETENTIONLEVEL, text::CSV ),
			text::P( static::ALTERNATEREADSERVER, text::CSV ),
			text::P( static::PRESERVEMPX, text::CSV ),
			text::P( static::DDOSTATE, text::CSV ),
			text::P( static::SOURCE, text::CSV ),
			text::P( static::UNUSED, text::CSV ),
			text::P( static::OPERATIONID, text::CSV ),
			text::P( static::OPERATIONINDEX, text::CSV ),
			text::P( static::SLPWINDOW, text::CSV ),
			text::P( static::TARGETMASTER, text::CSV ),
			text::P( static::TARGETMASTERSLP, text::CSV )
		);
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->add_fields( static::UPDATED, $this->updated( date( 'Y-m-d H:i:s' ) ) );
		$this->add_fields( static::OBSOLETED, NULL );
	}

	protected function parse_split( $split ) {
//		$split = str_replace( '*NULL*', 'NULL', $split );
		$split = str_replace( '*ANY*', 'ANY', $split );
		$row = array( );
		$pattern = '^(\S+) (\S+) (\S+) (\S+) (\S+)$';
		if ( preg_match( sprintf( '/%s/', $pattern ), $split, $match ) ) {
			array_shift( $match );
			foreach ( $this->fields( ) as $name => $type ) {
				$row[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
			}
			list(
				$row[ static::SLPNAME ],
				$row[ static::DATACLASSIFICATION ],
				$row[ static::DUPLICATIONPRIORITY ],
				$row[ static::STATE ],
				$row[ static::VERSION ]
			) = $match;
			$this->slps_row( $row );
			$row = array( );
		} else {
			$pattern = '^(\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+)$';
			if ( preg_match( sprintf( '/%s/', $pattern ), $split, $match ) ) {
				array_shift( $match );
				$row = $this->slps_row( );
				list(
					$row[ static::USEFOR ],
					$row[ static::STORAGEUNIT ],
					$row[ static::VOLUMEPOOL ],
					$row[ static::MEDIAOWNER ],
					$row[ static::RETENTIONTYPE ],
					$row[ static::RETENTIONLEVEL ],
					$row[ static::ALTERNATEREADSERVER ],
					$row[ static::PRESERVEMPX ],
					$row[ static::DDOSTATE ],
					$row[ static::SOURCE ],
					$row[ static::UNUSED ],
					$row[ static::OPERATIONID ],
					$row[ static::OPERATIONINDEX ],
					$row[ static::SLPWINDOW ],
					$row[ static::TARGETMASTER ],
					$row[ static::TARGETMASTERSLP ]
				) = $match;
			} else { throw new exception( sprintf( static::PARSING_EXCEPTION, $this->arguments( ) ) ); }
		}
		unset( $match );
		foreach ( $row as $key => $value ) if ( $value == '*NULL*' ) $row[ $key ] = '';
		return $row;
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->slps( sprintf( '%s_%s', $row[ static::SLPNAME ], $row[ static::OPERATIONID ] ), $row );
	}

	public function sql( $table = NULL, $rows = NULL ) {
		$result = parent::sql( $table, $rows );
		$result[ ] = sprintf( "update %s set %s=%s where %s='%s' and %s is null and %s<'%s';", $table,
			static::OBSOLETED, static::UPDATED, 
			static::MASTERSERVER, nbu( )->masterserver( ), 
			static::OBSOLETED, 
			static::UPDATED, $this->updated( ) );
		return $result;
	}
	
}


### BPPLCLIENTS

class bpplclients extends nbu {
	const WIN_BIN		= 'admincmd\\bpplclients';
	const ARGUMENTS		= '-allunique -l';
	const NAME			= 'name';
	const ARCHITECTURE	= 'architecture';
	const OS			= 'os';
	const PRIORITY		= 'priority';
	const UNUSED1		= 'u1';
	const UNUSED2		= 'u2';
	const UNUSED3		= 'u3';
	const UPDATED		= 'updated';
	const OBSOLETED		= 'obsoleted';

	private $updated	= '';
	private $clients	= array( );
	
	public function updated( $value = NULL ) { return _var( $this->updated, func_get_args( ) ); }
	public function clients( $field = NULL, $value = NULL) { return _arr( $this->clients, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array(
			'CLIENT',
			text::P(static::NAME, text::CSV ),
			text::P(static::ARCHITECTURE, text::CSV ),
			text::P(static::OS, text::CSV ),
			text::P(static::PRIORITY, text::CSV ),
			text::P(static::UNUSED1, text::CSV ),
			text::P(static::UNUSED2, text::CSV ),
			text::P(static::UNUSED3, text::CSV )
		);
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->add_fields( static::UPDATED, $this->updated( date( 'Y-m-d H:i:s' ) ) );
		$this->add_fields( static::OBSOLETED, NULL );
	}

	protected function parse_split( $split ) {
		$split = str_replace( '*NULL*', '', $split );
		return parent::parse_split( $split );	
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->clients( $row[ static::NAME ], $row );
	}

	public function sql( $table = NULL, $rows = NULL ) {
		$result = parent::sql( $table, $rows );
		$result[ ] = sprintf( "update %s set %s=%s where %s='%s' and %s is null and %s<'%s';", $table,
			static::OBSOLETED, static::UPDATED, 
			static::MASTERSERVER, nbu( )->masterserver( ), 
			static::OBSOLETED, 
			static::UPDATED, $this->updated( ) );
		return $result;
	}
	
}

### BPFLIST

class bpflist_backupid extends nbu {
	const WIN_BIN				= 'admincmd\\bpflist';
	const ARGUMENTS				= '-l -backupid %s';
	const VALID_EXITCODES		= '0,227';

	const IMAGE_VERSION			= 'image_version';
	const CLIENT_TYPE			= 'client_type';
	const START_TIME			= 'start_time';
	const TIMESTAMP				= 'timestamp';
	const SCHEDULE_TYPE			= 'schedule_type';
	const CLIENT				= 'client';
	const POLICY_NAME			= 'policy_name';
	const BACKUPID				= 'backupid';
	const PEER_NAME				= 'peer_name';
	const LINES					= 'lines';
	const OPTIONS				= 'options';
	const USER_NAME				= 'user_name';
	const GROUP_NAME			= 'group_name';
	const RAW_PARTITION_ID		= 'raw_partition_id';
	const JOBID					= 'jobid';

	const FILE_NUMBER			= 'file_number';
	const COMPRESSED_SIZE		= 'compressed_size';
	const PATH_LENGTH			= 'path_length';
	const DATA_LENGTH			= 'data_length';
	const BLOCK					= 'block';
	const IN_IMAGE				= 'in_image';
	const RAW_SIZE				= 'raw_size';
	const GB					= 'gb';
	const DEVICE_NUMBER			= 'device_number';
	const PATH					= 'path';
	const DIRECTORY_BITS		= 'directory_bits';
	const OWNER					= 'owner';
	const GROUP					= 'group';
	const BYTES					= 'bytes';
	const ACCESS_TIME			= 'access_time';
	const MODIFICATION_TIME		= 'modification_time';
	const INODE_TIME			= 'inode_time';
	const PARSING_EXCEPTION		= 'Parsing error (%s).';

	private $files				= array( );
	private $files_row			= array( );

	public function files( $field = NULL, $value = NULL) { return _arr( $this->files, func_get_args( ) ); }
	public function files_row( $field = NULL, $value = NULL) { return _arr( $this->files_row, func_get_args( ) ); }

	protected function setup( ) {
		parent::setup( );
//		$this->ignore_lines( NULL, 'no entity was found' );
	}

	public static function pattern( ) {
		$pattern = array(
			text::P( static::IMAGE_VERSION, text::CSV ),
			text::P( static::CLIENT_TYPE, text::CSV ),
			text::P( static::START_TIME, text::CSV ),
			text::P( static::TIMESTAMP, text::CSV ),
			text::P( static::SCHEDULE_TYPE, text::CSV ),
			text::P( static::CLIENT, text::CSV ),
			text::P( static::POLICY_NAME, text::CSV ),
			text::P( static::BACKUPID, text::CSV ),
			text::P( static::PEER_NAME, text::CSV ),
			text::P( static::LINES, text::CSV ),
			text::P( static::OPTIONS, text::CSV ),
			text::P( static::USER_NAME, text::CSV ),
			text::P( static::GROUP_NAME, text::CSV ),
			text::P( static::RAW_PARTITION_ID, text::CSV ),
			text::P( static::JOBID, text::CSV ),
			text::P( static::FILE_NUMBER, text::CSV ),
			text::P( static::COMPRESSED_SIZE, text::CSV ),
			text::P( static::PATH_LENGTH, text::CSV ),
			text::P( static::DATA_LENGTH, text::CSV ),
			text::P( static::BLOCK, text::CSV ),
			text::P( static::IN_IMAGE, text::CSV ),
			text::P( static::RAW_SIZE, text::CSV ),
			text::P( static::GB, text::CSV ),
			text::P( static::DEVICE_NUMBER, text::CSV ),
			text::P( static::PATH, text::CSV ),
			text::P( static::DIRECTORY_BITS, text::CSV ),
			text::P( static::OWNER, text::CSV ),
			text::P( static::GROUP, text::CSV ),
			text::P( static::BYTES, text::CSV ),
			text::P( static::ACCESS_TIME, text::CSV ),
			text::P( static::MODIFICATION_TIME, text::CSV ),
			text::P( static::INODE_TIME, text::CSV )
		);
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function parse_split( $split ) {
		$split = str_replace( '*NULL*', '', $split );
		$split = str_replace( '*ANY*', 'ANY', $split );
		$row = array( );
		$pattern = 'no entity was found';
		if ( preg_match( sprintf( '/%s/', $pattern ), $split, $match ) ) {
			foreach ( $this->fields( ) as $name => $type ) {
				$row[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
			}
			$row[ static::IMAGE_VERSION ] = 0;
			$row[ static::CLIENT_TYPE ] = 0;
			$row[ static::START_TIME ] = 0;
			$row[ static::TIMESTAMP ] = 0;
			$row[ static::SCHEDULE_TYPE ] = 0;
			$row[ static::CLIENT ] = 'N/A';
			$row[ static::POLICY_NAME ] = 'N/A';
			$row[ static::BACKUPID ] = $this->arguments( );
			$row[ static::PEER_NAME ] = 'N/A';
			$row[ static::LINES ] = 0;
			$row[ static::OPTIONS ] = 0;
			$row[ static::USER_NAME ]= 'N/A';
			$row[ static::GROUP_NAME ] = 'N/A';
			$row[ static::RAW_PARTITION_ID ] = 0;
			$row[ static::JOBID ] = 0;
			$row[ static::FILE_NUMBER ] = 0;
			$row[ static::COMPRESSED_SIZE ] = 0;
			$row[ static::PATH_LENGTH ] = 0;
			$row[ static::DATA_LENGTH ] = 0;
			$row[ static::BLOCK ] = 0;
			$row[ static::IN_IMAGE ] = 0;
			$row[ static::RAW_SIZE ] = 0;
			$row[ static::GB ] = 0;
			$row[ static::DEVICE_NUMBER ] = 0;
			$row[ static::PATH ] = $pattern;
			$row[ static::DIRECTORY_BITS ] = 0;
			$row[ static::OWNER ] = 'N/A';
			$row[ static::GROUP ] = 'N/A';
			$row[ static::BYTES ] = 0;
			$row[ static::ACCESS_TIME ] = 0;
			$row[ static::MODIFICATION_TIME ] = 0;
			$row[ static::INODE_TIME ] = 0;
		}
		$pattern = '^FILES (\S+) (\S+) +(\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) +(\S+) (\S+) (\S+) (\S+) (\S+) (\S+)';
		if ( $row == array( ) and preg_match( sprintf( '/%s/', $pattern ), $split, $match ) ) {
			array_shift( $match );
			foreach ( $this->fields( ) as $name => $type ) {
				$row[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
			}
			list(
				$row[ static::IMAGE_VERSION ],
				$row[ static::CLIENT_TYPE ],
				$row[ static::START_TIME ],
				$row[ static::TIMESTAMP ],
				$row[ static::SCHEDULE_TYPE ],
				$row[ static::CLIENT ],
				$row[ static::POLICY_NAME ],
				$row[ static::BACKUPID ],
				$row[ static::PEER_NAME ],
				$row[ static::LINES ],
				$row[ static::OPTIONS ],
				$row[ static::USER_NAME ],
				$row[ static::GROUP_NAME ],
				$row[ static::RAW_PARTITION_ID ],
				$row[ static::JOBID ]
			) = $match;
			$this->files_row( $row );
		}
		$pattern = '^(\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\/[^\/]*\/?) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+) (\S+)';
		if ( $row == array( ) ) {
			if ( preg_match( sprintf( '/%s/', $pattern ), $split, $match ) ) {
				array_shift( $match );
				$row = $this->files_row( );
				list(
					$row[ static::FILE_NUMBER ],
					$row[ static::COMPRESSED_SIZE ],
					$row[ static::PATH_LENGTH ],
					$row[ static::DATA_LENGTH ],
					$row[ static::BLOCK ],
					$row[ static::IN_IMAGE ],
					$row[ static::RAW_SIZE ],
					$row[ static::GB ],
					$row[ static::DEVICE_NUMBER ],
					$row[ static::PATH ],
					$row[ static::DIRECTORY_BITS ],
					$row[ static::OWNER ],
					$row[ static::GROUP ],
					$row[ static::BYTES ],
					$row[ static::ACCESS_TIME ],
					$row[ static::MODIFICATION_TIME ],
					$row[ static::INODE_TIME ]
				) = $match;
			} else { throw new exception( sprintf( static::PARSING_EXCEPTION, $this->arguments( ) ) ); }
		}
		unset( $match );
		return $row;
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->files( sprintf( '%s_%s', $row[ static::BACKUPID ], $row[ static::FILE_NUMBER ] ), $row );
	}
}

### BPIMAGELIST

class bpimagelist extends nbu {
	const WIN_BIN	= 'admincmd\\bpimagelist';
}

class bpimagelist_hoursago extends bpimagelist {
	const ARGUMENTS				= '-l -hoursago %s';
	const CLIENT_NAME			= 'name';
	const DATE1					= 'date1';
	const DATE2					= 'date2';
	const VERSION				= 'version';
	const BACKUPID				= 'backupid';
	const POLICY_NAME			= 'policy_name';
	const CLIENT_TYPE			= 'client_type';
	const PROXY_CLIENT			= 'proxy_client';
	const CREATOR				= 'creator';
	const SCHED_LABEL			= 'sched_label';
	const SCHED_TYPE			= 'sched_type';
	const RETENTION				= 'retention';
	const BACKUP_TIME			= 'backup_time';
	const ELAPSED				= 'elapsed';
	const EXPIRATION			= 'expiration';
	const COMPRESSION			= 'compression';
	const ENCRYPTION			= 'encryption';
	const KBYTES				= 'kbytes';
	const NUM_FILES				= 'num_files';
	const COPIES				= 'copies';
	const NUM_FRAGMENTS			= 'num_fragments';
	const FILES_COMPRESSED		= 'files_compressed';
	const FILES_FILE			= 'files_file';
	const SW_VERSION			= 'sw_version';
	const NAME1					= 'name1';
	const OPTIONS				= 'options';
	const PRIMARY				= 'primary';
	const IMAGE_TYPE			= 'image_type';
	const TIR_INFO				= 'tir_info';
	const TIR_EXPIRATION		= 'tir_expiration';
	const KEYWORDS				= 'keywords';
	const MPX 					= 'mpx';
	const EXT_SECURITY			= 'ext_security';
	const RAW					= 'raw';
	const DUMP_LVL				= 'dump_lvl';
	const FS_ONLY				= 'fs_only';
	const PREV_BITIME			= 'prev_bitime';
	const BIFULL_TIME			= 'bifull_time';
	const OBJ_DESC				= 'obj_desc';
	const REQUESTID				= 'requestid';
	const BACKUP_STAT			= 'backup_stat';
	const BACKUP_COPY			= 'backup_copy';
	const PREV_IMAGE			= 'prev_image';
	const JOBID					= 'jobid';
	const NUM_RESUMES			= 'num_resumes';
	const RESUME_EXPR			= 'resume_expr';
	const FF_SIZE				= 'ff_size';
	const PFI_TYPE				= 'pfi_type';
	const IMAGE_ATTRIB			= 'image_attrib';
	const SS_CLASSIFICATION_ID	= 'ss_classification_id';
	const SS_NAME				= 'ss_name';
	const SS_COMPLETED			= 'ss_completed';
	const SS_SNAP_TIME			= 'snap_time';
	const SLP_VERSION			= 'slp_version';
	const REMOTE_EXPIRATION		= 'remote_expiration';
	const ORIGIN_MASTER_SERVER	= 'origin_master_server';
	const ORIGIN_MASTER_GUID	= 'origin_master_guid';
	const IR_ENABLED			= 'ir_enabled';
	const CLIENT_CHARSET		= 'client_charset';
	const HOLD					= 'hold';
	const INDEXING_STATUS		= 'indexing_status';

	private $images			= array( );
	private $frags			= array( );
	private $_frags			= NULL;

	public function _frags( $value = NULL ) { return _var( $this->_frags, func_get_args( ) ); }
	public function images( $field = NULL, $value = NULL) { return _arr( $this->images, func_get_args( ) ); }
	public function frags( $field = NULL, $value = NULL) { return _arr( $this->frags, func_get_args( ) ); }

	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( '^(?=IMAGE)' );
		$this->_frags( new bpimagelist_frags( ) );
		$this->_frags->add_fields( static::BACKUPID, '' );
	}

	protected function parse_split( $split ) {
		$match = array( );
		foreach( explode( PHP_EOL, $split ) as $line ) {
			$line = str_replace( '*NULL*', '', $line );
			$line = str_replace( '*ANY*', 'ANY', $line );
			$value = explode( ' ', $line );
			$field = array_shift( $value );
			count( $value ) == 1 && $value = $value[ 0 ];
			$match[ $field ][ ] = $value;
		}
		foreach( $match as $key => $value )
			is_array( $value ) && count( $value ) == 1 && $match[ $key ] = empty( $value[ 0 ] ) ? NULL : $value[ 0 ];
		$row = array( );
		foreach ( $this->fields( ) as $name => $type ) {
			$row[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
		}
		list(
			$row[ static::CLIENT_NAME ],
			$row[ static::DATE1 ],
			$row[ static::DATE2 ],
			$row[ static::VERSION ],
			$row[ static::BACKUPID ],
			$row[ static::POLICY_NAME ],
			$row[ static::CLIENT_TYPE ],
			$row[ static::PROXY_CLIENT ],
			$row[ static::CREATOR ],
			$row[ static::SCHED_LABEL ],
			$row[ static::SCHED_TYPE ],
			$row[ static::RETENTION ],
			$row[ static::BACKUP_TIME ],
			$row[ static::ELAPSED ],
			$row[ static::EXPIRATION ],
			$row[ static::COMPRESSION ],
			$row[ static::ENCRYPTION ],
			$row[ static::KBYTES ],
			$row[ static::NUM_FILES ],
			$row[ static::COPIES ],
			$row[ static::NUM_FRAGMENTS ],
			$row[ static::FILES_COMPRESSED ],
			$row[ static::FILES_FILE ],
			$row[ static::SW_VERSION ],
			$row[ static::NAME1 ],
			$row[ static::OPTIONS ],
			$row[ static::PRIMARY ],
			$row[ static::IMAGE_TYPE ],
			$row[ static::TIR_INFO ],
			$row[ static::TIR_EXPIRATION ],
			$row[ static::KEYWORDS ],
			$row[ static::MPX ],
			$row[ static::EXT_SECURITY ],
			$row[ static::RAW ],
			$row[ static::DUMP_LVL ],
			$row[ static::FS_ONLY ],
			$row[ static::PREV_BITIME ],
			$row[ static::BIFULL_TIME ],
			$row[ static::OBJ_DESC ],
			$row[ static::REQUESTID ],
			$row[ static::BACKUP_STAT ],
			$row[ static::BACKUP_COPY ],
			$row[ static::PREV_IMAGE ],
			$row[ static::JOBID ],
			$row[ static::NUM_RESUMES ],
			$row[ static::RESUME_EXPR ],
			$row[ static::FF_SIZE ],
			$row[ static::PFI_TYPE ],
			$row[ static::IMAGE_ATTRIB ],
			$row[ static::SS_CLASSIFICATION_ID ],
			$row[ static::SS_NAME ],
			$row[ static::SS_COMPLETED ],
			$row[ static::SS_SNAP_TIME ],
			$row[ static::SLP_VERSION ],
			$row[ static::REMOTE_EXPIRATION ],
			$row[ static::ORIGIN_MASTER_SERVER ],
			$row[ static::ORIGIN_MASTER_GUID ],
			$row[ static::IR_ENABLED ],
			$row[ static::CLIENT_CHARSET ],
			$row[ static::HOLD ],
			$row[ static::INDEXING_STATUS ]
		) = $match[ 'IMAGE' ];
		unset( $match );
		foreach( $row as $key => $value ) {
			$this->fields( $key ) || $this->fields( $key, field::STRING );
			if ( is_array( $row[ $key ] ) ) {
				$row[ $key ] = serialize( $row[ $key ] );
			}
			$row[ $key ] = field::validate( $row[ $key ] );
		}
		$frags = new bpimagelist_frags( );
		$frags->add_fields( static::BACKUPID, $row[ static::BACKUPID ] );
		$frags->parse( $split );
		$this->_frags->fields( $frags->fields( ) );
		$this->_frags->rows( array_merge( $this->_frags->rows( ), $frags->rows( ) ) );
		$this->frags( array_merge( $this->frags( ), $frags->frags( ) ) );
		$this->parsing_errors( array_merge( $this->parsing_errors( ), $frags->parsing_errors( ) ) );
		unset( $frags );
		return $row;
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->images( $row[ static::BACKUPID ], $row );
	}
	
	public function sql( $table = NULL, $rows = NULL ) {
		$result = array_merge( parent::sql( get_class( $this ), $rows ), $this->_frags( )->sql( get_class( $this->_frags( ) ), $rows ) );
		return $result;
	}
}

class bpimagelist_frags extends nbu {
	const BACKUPID				= 'backupid';
	const COPY_NUMBER			= 'copy_number';
	const FRAGMENT_NUMBER		= 'fragment_number';
	const KILOBYTES				= 'kilobytes';
	const REMAINDER				= 'remainder';
	const MEDIA_TYPE			= 'media_type';
	const DENSITY				= 'density';
	const FILE_NUMBER			= 'file_number';
	const ID_PATH				= 'id_path';
	const HOST					= 'host';
	const BLOCK_SIZE			= 'block_size';
	const OFFSET				= 'offset';
	const MEDIA_DATE			= 'media_date';
	const DEVICE_WRITTEN_ON		= 'device_written_on';
	const F_FLAGS				= 'f_flags';
	const MEDIA_DESCRIPTOR		= 'media_descriptor';
	const EXPIRATION			= 'expiration';
	const MPX					= 'mpx';
	const RETENTION_LEVEL		= 'retention_level';
	const CHECKPOINT			= 'checkpoint';
	const RESUME_NBR			= 'resume_nbr';
	const MEDIA_SEQ				= 'media_seq';
	const MEDIA_SUBTYPE			= 'media_subtype';
	const TRY_TO_KEEP_TIME		= 'try_to_keep_time';
	const COPY_CREATION_TIME	= 'copy_creation_time';
	const FRAGMENT_STATE		= 'fragment_state';
	const DATA_FORMAT			= 'data_format';
	const KEY_TAG				= 'key_tag';
	const STL_TAG				= 'stl_tag';
	const MIRROR_PARENT			= 'mirror_parent';
	const COPY_ON_HOLD			= 'copy_on_hold';

	private $frags			= array( );

	public function frags( $field = NULL, $value = NULL) { return _arr( $this->frags, func_get_args( ) ); }

	public static function pattern( ) {
		$pattern = array(
			'FRAG',
			text::P(static::COPY_NUMBER, text::CSV ),
			text::P(static::FRAGMENT_NUMBER, text::CSV ),
			text::P(static::KILOBYTES, text::CSV ),
			text::P(static::REMAINDER, text::CSV ),
			text::P(static::MEDIA_TYPE, text::CSV ),
			text::P(static::DENSITY, text::CSV ),
			text::P(static::FILE_NUMBER, text::CSV ),
			text::P(static::ID_PATH, text::CSV ),
			text::P(static::HOST, text::CSV ),
			text::P(static::BLOCK_SIZE, text::CSV ),
			text::P(static::OFFSET, text::CSV ),
			text::P(static::MEDIA_DATE, text::CSV ),
			text::P(static::DEVICE_WRITTEN_ON, text::CSV ),
			text::P(static::F_FLAGS, text::CSV ),
			text::P(static::MEDIA_DESCRIPTOR, text::CSV ),
			text::P(static::EXPIRATION, text::CSV ),
			text::P(static::MPX, text::CSV ),
			text::P(static::RETENTION_LEVEL, text::CSV ),
			text::P(static::CHECKPOINT, text::CSV ),
			text::P(static::RESUME_NBR, text::CSV ),
			text::P(static::MEDIA_SEQ, text::CSV ),
			text::P(static::MEDIA_SUBTYPE, text::CSV ),
			text::P(static::TRY_TO_KEEP_TIME, text::CSV ),
			text::P(static::COPY_CREATION_TIME, text::CSV ),
			text::P(static::FRAGMENT_STATE, text::CSV ),
			text::P(static::DATA_FORMAT, text::CSV ),
			text::P(static::KEY_TAG, text::CSV ),
			text::P(static::STL_TAG, text::CSV ),
			text::P(static::MIRROR_PARENT, text::CSV ),
			text::P(static::COPY_ON_HOLD, text::CSV )
		);
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( '^(?=FRAG)' );
		$this->ignore_lines( NULL, '^(IMAGE|HISTO)' );
	}

	protected function parse_split( $split ) {
		$split = str_replace( '*NULL*', '', $split );
		return parent::parse_split( $split );	
	}
	
	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->frags( sprintf( '%s_%s', $row[ static::BACKUPID ], $row[ static::FRAGMENT_NUMBER ] ), $row );
	}
}

### BPIMMEDIA

class bpimmedia extends nbu {
	const WIN_BIN	= 'admincmd\\bpimmedia';
	const ARGUMENTS				= '-l -d %s';
	const CLIENT_NAME			= 'name';
	const VERSION				= 'version';
	const BACKUPID				= 'backupid';
	const POLICY_NAME			= 'policy_name';
	const POLICY_TYPE			= 'policy_type';
	const SCHED_LABEL			= 'sched_label';
	const SCHED_TYPE			= 'sched_type';
	const RETENTION				= 'retention';
	const NUM_FILES				= 'num_files';
	const EXPIRATION			= 'expiration';
	const COMPRESSION			= 'compression';
	const ENCRYPTION			= 'encryption';
	const HOLD					= 'hold';

	private $images			= array( );
	private $frags			= array( );
	private $_frags			= NULL;

	public function _frags( $value = NULL ) { return _var( $this->_frags, func_get_args( ) ); }
	public function images( $field = NULL, $value = NULL) { return _arr( $this->images, func_get_args( ) ); }
	public function frags( $field = NULL, $value = NULL) { return _arr( $this->frags, func_get_args( ) ); }

	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( '^(?=IMAGE)' );
		$this->ignore_lines( NULL, 'no entity was found' );
		$this->_frags( new bpimmedia_frags( ) );
		$this->_frags->add_fields( static::BACKUPID, '' );
	}

	protected function parse_split( $split ) {
		$match = array( );
		foreach( explode( PHP_EOL, $split ) as $line ) {
			$value = explode( ' ', $line );
			$field = array_shift( $value );
			count( $value ) == 1 && $value = $value[ 0 ];
			$match[ $field ][ ] = $value;
		}
		foreach( $match as $key => $value )
			is_array( $value ) && count( $value ) == 1 && $match[ $key ] = empty( $value[ 0 ] ) ? NULL : $value[ 0 ];
		$row = array( );
		foreach ( $this->fields( ) as $name => $type ) {
			$row[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
		}
		list(
			$row[ static::CLIENT_NAME ],
			$row[ static::VERSION ],
			$row[ static::BACKUPID ],
			$row[ static::POLICY_NAME ],
			$row[ static::POLICY_TYPE ],
			$row[ static::SCHED_LABEL ],
			$row[ static::SCHED_TYPE ],
			$row[ static::RETENTION ],
			$row[ static::NUM_FILES ],
			$row[ static::EXPIRATION ],
			$row[ static::COMPRESSION ],
			$row[ static::ENCRYPTION ],
			$row[ static::HOLD ]
		) = $match[ 'IMAGE' ];
		unset( $match );
		foreach( $row as $key => $value ) {
			$this->fields( $key ) || $this->fields( $key, field::STRING );
			if ( is_array( $row[ $key ] ) ) {
				$row[ $key ] = serialize( $row[ $key ] );
			}
			$row[ $key ] = field::validate( $row[ $key ] );
		}
		if ( $row[ static::SCHED_TYPE ] == 2 and ( $row[ static::POLICY_TYPE ] == 4 or $row[ static::POLICY_TYPE ] == 15 ) ) return array( );
		$frags = new bpimmedia_frags( );
		$frags->add_fields( static::BACKUPID, $row[ static::BACKUPID ] );
		$frags->parse( $split );
		$this->_frags->fields( $frags->fields( ) );
		$this->_frags->rows( array_merge( $this->_frags->rows( ), $frags->rows( ) ) );
		$this->frags( array_merge( $this->frags( ), $frags->frags( ) ) );
		$this->parsing_errors( array_merge( $this->parsing_errors( ), $frags->parsing_errors( ) ) );
		unset( $frags );
		return $row;
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->images( $row[ static::BACKUPID ], $row );
	}
	
	public function sql( $table = NULL, $rows = NULL ) {
		$result = count( $this->images( ) ) == 0 ? '' : array_merge( parent::sql( 'bpimmedia', $rows ), $this->_frags( )->sql( get_class( $this->_frags( ) ), $rows ) );
		return $result;
	}
}

class bpimmedia_client extends bpimmedia {
	const ARGUMENTS				= '-l -client %s';
}

class bpimmedia_frags extends nbu {
	const BACKUPID				= 'backupid';
	const COPY_NUMBER			= 'copy_number';
	const FRAGMENT_NUMBER		= 'fragment_number';
	const KILOBYTES				= 'kilobytes';
	const REMAINDER				= 'remainder';
	const MEDIA_TYPE			= 'media_type';
	const DENSITY				= 'density';
	const FILE_NUMBER			= 'file_number';
	const ID_PATH				= 'id_path';
	const HOST					= 'host';
	const BLOCK_SIZE			= 'block_size';
	const OFFSET				= 'offset';
	const MEDIA_DATE			= 'media_date';
	const DEVICE_WRITTEN_ON		= 'device_written_on';
	const F_FLAGS				= 'f_flags';
	const MEDIA_DESCRIPTOR		= 'media_descriptor';
	const EXPIRATION			= 'expiration';
	const MPX					= 'mpx';
	const RETENTION_LEVEL		= 'retention_level';
	const CHECKPOINT			= 'checkpoint';
	const COPY_ON_HOLD			= 'copy_on_hold';

	private $frags			= array( );

	public function frags( $field = NULL, $value = NULL) { return _arr( $this->frags, func_get_args( ) ); }

	public static function pattern( ) {
		$pattern = array(
			'FRAG',
			text::P(static::COPY_NUMBER, text::CSV ),
			text::P(static::FRAGMENT_NUMBER, text::CSV ),
			text::P(static::KILOBYTES, text::CSV ),
			text::P(static::REMAINDER, text::CSV ),
			text::P(static::MEDIA_TYPE, text::CSV ),
			text::P(static::DENSITY, text::CSV ),
			text::P(static::FILE_NUMBER, text::CSV ),
			text::P(static::ID_PATH, text::CSV ),
			text::P(static::HOST, text::CSV ),
			text::P(static::BLOCK_SIZE, text::CSV ),
			text::P(static::OFFSET, text::CSV ),
			text::P(static::MEDIA_DATE, text::CSV ),
			text::P(static::DEVICE_WRITTEN_ON, text::CSV ),
			text::P(static::F_FLAGS, text::CSV ),
			text::P(static::MEDIA_DESCRIPTOR, text::CSV ),
			text::P(static::EXPIRATION, text::CSV ),
			text::P(static::MPX, text::CSV ),
			text::P(static::RETENTION_LEVEL, text::CSV ),
			text::P(static::CHECKPOINT, text::CSV ),
			text::P(static::COPY_ON_HOLD, text::CSV )
		);
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( '^(?=FRAG)' );
		$this->ignore_lines( NULL, '^(IMAGE|HISTO|no entity was found)' );
	}

	protected function parse_split( $split ) {
		$row = parent::parse_split( $split );	
		foreach ( $row as $key => $value ) if ( $value == '*NULL*' ) $row[ $key ] = '';
		return $row;
	}
	
	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->frags( sprintf( '%s_%s', $row[ static::BACKUPID ], $row[ static::FRAGMENT_NUMBER ] ), $row );
	}
}

### BPDBJOBS

class bpdbjobs extends nbu {
	const WIN_BIN	= 'admincmd\\bpdbjobs';
}

class bpdbjobs_summary extends bpdbjobs {
	const ARGUMENTS		= '-summary -l';
	const MASTERSERVER	= 'masterserver';
	const QUEUED		= 'queued';
	const WAITING		= 'waiting';
	const ACTIVE		= 'active';
	const SUCCESSFUL	= 'successful';
	const PARTIAL		= 'partial';
	const FAILED		= 'failed';
	const INCOMPLETE	= 'incomplete';
	const SUSPENDED		= 'suspended';
	const TOTAL			= 'total';
	private $summary = array( );

	public function summary( $field = NULL, $value = NULL) { return _arr( $this->summary, func_get_args( ) ); }

	public static function pattern( ) {
		$pattern = array(
			sprintf( 'Summary of jobs on %s', text::P( static::MASTERSERVER, nbu::HOSTNAME ) ),
			sprintf( 'Queued:\s+%s', text::P( static::QUEUED ) ),
			sprintf( 'Waiting-to-Retry:\s+%s', text::P( static::WAITING ) ),
			sprintf( 'Active:\s+%s', text::P( static::ACTIVE ) ),
			sprintf( 'Successful:\s+%s', text::P( static::SUCCESSFUL ) ),
			sprintf( 'Partially Successful:\s+%s', text::P( static::PARTIAL ) ),
			sprintf( 'Failed:\s+%s', text::P( static::FAILED ) ),
			sprintf( 'Incomplete:\s+%s', text::P( static::INCOMPLETE ) ),
			sprintf( 'Suspended:\s+%s', text::P( static::SUSPENDED ) ),
			sprintf( 'Total:\s+%s', text::P( static::TOTAL ) ) );
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( text::DOUBLE_NEW_LINE );
		$this->fields( static::QUEUED, field::INTEGER );
		$this->fields( static::WAITING, field::INTEGER );
		$this->fields( static::ACTIVE, field::INTEGER );
		$this->fields( static::SUCCESSFUL, field::INTEGER );
		$this->fields( static::PARTIAL, field::INTEGER );
		$this->fields( static::FAILED, field::INTEGER );
		$this->fields( static::QUEUED, field::INTEGER );
		$this->fields( static::INCOMPLETE, field::INTEGER );
		$this->fields( static::SUSPENDED, field::INTEGER );
		$this->fields( static::TOTAL, field::INTEGER );
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->summary( $row );
		nbu( )->masterserver( $this->summary( static::MASTERSERVER ) );
	}
}

class bpdbjobs_report extends bpdbjobs {
	const ARGUMENTS				= '-report -most_columns -t %s';
	const JOBID					= 'jobid';
	const JOBTYPE				= 'jobtype';
	const STATE					= 'state';
	const STATUS				= 'status';
	const POLICY				= 'policy';
	const SCHEDULE				= 'schedule';
	const CLIENT				= 'client';
	const SERVER				= 'server';
	const STARTED				= 'started';
	const ELAPSED				= 'elapsed';
	const ENDED					= 'ended';
	const STUNIT				= 'stunit';
	const TRIES					= 'tries';
	const OPERATION				= 'operation';
	const KBYTES				= 'kbytes';
	const FILES					= 'files';
	const PATHLASTWRITTEN		= 'pathlastwritten';
	const PERCENT				= 'percent';
	const JOBPID				= 'jobpid';
	const OWNER					= 'owner';
	const SUBTYPE				= 'subtype';
	const POLICYTYPE			= 'policytype';
	const SCHEDULETYPE			= 'scheduletype';
	const PRIORITY				= 'priority';
	const GROUP					= 'group';
	const MASTERSERVER			= 'masterserver';
	const RETENTIONLEVEL		= 'retentionlevel';
	const RETENTIONPERIOD		= 'retentionperiod';
	const COMPRESSION			= 'compression';
	const KBYTESTOBEWRITTEN		= 'kbytestobewritten';
	const FILESTOBEWRITTEN		= 'filestobewritten';
	const FILELISTCOUNT			= 'filelistcount';
	const TRYCOUNT				= 'trycount';
	const PARENTJOB				= 'parentjob';
	const KBPERSEC				= 'kbpersec';
	const COPY					= 'copy';
	const ROBOT					= 'robot';
	const VAULT					= 'vault';
	const PROFILE				= 'profile';
	const SESSION				= 'session';
	const EJECTTAPES			= 'ejecttapes';
	const SRCSTUNIT				= 'srcstunit';
	const SRCSERVER				= 'srcserver';
	const SRCMEDIA				= 'srcmedia';
	const DSTMEDIA				= 'dstmedia';
	const STREAM				= 'stream';
	const SUSPENDABLE			= 'suspendable';
	const RESUMABLE				= 'resumable';
	const RESTARTABLE			= 'restartable';
	const DATAMOVEMENT			= 'datamovement';
	const SNAPSHOT				= 'snapshot';
	const BACKUPID				= 'backupid';
	const KILLABLE				= 'killable';
	const CONTROLLINGHOST		= 'controllinghost';
	const OFFHOSTTYPE			= 'offhosttype';
	const FTUSAGE				= 'ftusage';
	const QUEUEREASON			= 'queuereason';
	const REASONSTRING			= 'reasonstring';
	const DEDUPRATIO			= 'dedupratio';
	const ACCELERATOR			= 'accelerator';
	const INSTANCEDBNAME		= 'instancedbname';
	private $jobs 				= array( );

	public function jobs( $field = NULL, $value = NULL) { return _arr( $this->jobs, func_get_args( ) ); }

	public static function pattern( ) {
		$pattern = array(
			text::P( static::JOBID, text::CSV ),
			text::P( static::JOBTYPE, text::CSV ),
			text::P( static::STATE, text::CSV ),
			text::P( static::STATUS, text::CSV ),
			text::P( static::POLICY, text::CSV ),
			text::P( static::SCHEDULE, text::CSV ),
			text::P( static::CLIENT, text::CSV ),
			text::P( static::SERVER, text::CSV ),
			text::P( static::STARTED, text::CSV ),
			text::P( static::ELAPSED, text::CSV ),
			text::P( static::ENDED, text::CSV ),
			text::P( static::STUNIT, text::CSV ),
			text::P( static::TRIES, text::CSV ),
			text::P( static::OPERATION, text::CSV ),
			text::P( static::KBYTES, text::CSV ),
			text::P( static::FILES, text::CSV ),
			text::P( static::PATHLASTWRITTEN, text::CSV ),
			text::P( static::PERCENT, text::CSV ),
			text::P( static::JOBPID, text::CSV ),
			text::P( static::OWNER, text::CSV ),
			text::P( static::SUBTYPE, text::CSV ),
			text::P( static::POLICYTYPE, text::CSV ),
			text::P( static::SCHEDULETYPE, text::CSV ),
			text::P( static::PRIORITY, text::CSV ),
			text::P( static::GROUP, text::CSV ),
			text::P( static::MASTERSERVER, text::CSV ),
			text::P( static::RETENTIONLEVEL, text::CSV ),
			text::P( static::RETENTIONPERIOD, text::CSV ),
			text::P( static::COMPRESSION, text::CSV ),
			text::P( static::KBYTESTOBEWRITTEN, text::CSV ),
			text::P( static::FILESTOBEWRITTEN, text::CSV ),
			text::P( static::FILELISTCOUNT, text::CSV ),
			text::P( static::TRYCOUNT, text::CSV ),
			text::P( static::PARENTJOB, text::CSV ),
			text::P( static::KBPERSEC, text::CSV ),
			text::P( static::COPY, text::CSV ),
			text::P( static::ROBOT, text::CSV ),
			text::P( static::VAULT, text::CSV ),
			text::P( static::PROFILE, text::CSV ),
			text::P( static::SESSION, text::CSV ),
			text::P( static::EJECTTAPES, text::CSV ),
			text::P( static::SRCSTUNIT, text::CSV ),
			text::P( static::SRCSERVER, text::CSV ),
			text::P( static::SRCMEDIA, text::CSV ),
			text::P( static::DSTMEDIA, text::CSV ),
			text::P( static::STREAM, text::CSV ),
			text::P( static::SUSPENDABLE, text::CSV ),
			text::P( static::RESUMABLE, text::CSV ),
			text::P( static::RESTARTABLE, text::CSV ),
			text::P( static::DATAMOVEMENT, text::CSV ),
			text::P( static::SNAPSHOT, text::CSV ),
			text::P( static::BACKUPID, text::CSV ),
			text::P( static::KILLABLE, text::CSV ),
			text::P( static::CONTROLLINGHOST, text::CSV ),
#			text::P( static::OFFHOSTTYPE, text::CSV ),
			text::P( static::FTUSAGE, text::CSV ),
			text::P( static::QUEUEREASON, text::CSV ),
			text::P( static::REASONSTRING, text::CSV ),
			text::P( static::DEDUPRATIO, text::CSV ),
			text::P( static::ACCELERATOR, text::CSV ),
			text::P( static::INSTANCEDBNAME, text::CSV ),
			text::P( 'rest1', text::CSV ),
			text::P( 'rest2', text::CSV ) );
		return sprintf( static::PATTERN, implode( text::COMMA, $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, '^JobID' );
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->jobs( $row[ static::JOBID ], $row );
	}
}

### BPPLLIST

class bppllist extends nbu {
	const WIN_BIN	= 'admincmd\\bppllist';
}

class bppllist_allpolicies extends bppllist {
	const ARGUMENTS				= '-allpolicies';
	const UPDATED				= 'updated';
	const OBSOLETED				= 'obsoleted';
	private $updated			= '';
	public function updated( $value = NULL ) { return _var( $this->updated, func_get_args( ) ); }
	
	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( '^(?=CLASS)' );
		$this->add_fields( static::UPDATED, $this->updated( date( 'Y-m-d H:i:s' ) ) );
		$this->add_fields( static::OBSOLETED, NULL );
	}

	public function sql( $table = NULL, $rows = NULL ) {
		$result = parent::sql( $table, $rows );
		$result[ ] = sprintf( "update %s set %s=%s where %s='%s' and %s is null and %s<'%s';", $table,
			static::OBSOLETED, static::UPDATED, 
			static::MASTERSERVER, nbu( )->masterserver( ), 
			static::OBSOLETED, 
			static::UPDATED, $this->updated( ) );
		return $result;
	}
}

class bppllist_policies extends bppllist_allpolicies {
	const POLICYNAME			= 'name';
	const INTERNALNAME			= 'internalname';
	const OPTIONS				= 'options';
	const PROTOCOLVERSION		= 'protocolversion';
	const TIMEZONEOFFSET		= 'timezoneoffset';
	const AUDITREASON			= 'auditreason';
	const POLICYTYPE			= 'policytype';
	const FOLLOWNFSMOUNT		= 'follownfsmount';
	const CLIENTCOMPRESS		= 'clientcompress';
	const JOBPRIORITY			= 'jobpriority';
	const PROXYCLIENT			= 'proxyclient';
	const CLIENTENCRYPT			= 'clientencrypt';
	const DR					= 'dr';
	const MAXJOBSPERCLIENT		= 'maxjobsperclient';
	const CROSSMOUNTPOINTS		= 'crossmountpoints';
	const MAXFRAGSIZE			= 'maxfragsize';
	const ACTIVE				= 'active';
	const TIR					= 'tir';
	const BLOCKLEVELINCREMENTALS= 'blocklevelincrementals';
	const INDIVIDUALFILERESTORE	= 'individualfilerestore';
	const STREAMING				= 'streaming';
	const FROZENIMAGE			= 'frozenimage';
	const BACKUPCOPY			= 'backupcopy';
	const EFFECTIVEDATE			= 'effectivedate';
	const CLASSID				= 'classid';
	const BACKUPCOPIES			= 'backupcopies';
	const CHECKPOINTS			= 'checkpoints';
	const CHECKPOINTINTERVAL	= 'checkpointinterval';
	const UNUSED				= 'unused';
	const INSTANTRECOVERY		= 'instantrecovery';
	const OFFHOSTBACKUP			= 'offhostbackup';
	const ALTERNATECLIENT		= 'alternateclient';
	const DATAMOVER				= 'datamover';
	const DATAMOVERTYPE			= 'datamovertype';
	const BMR					= 'bmr';
	const LIFECYCLE				= 'lifecycle';
	const GRANULARRESTORE		= 'granularrestore';
	const JOBSUBTYPE			= 'jobsubtype';
	const VM					= 'vm';
	const IGNORECSDEDUP			= 'ignorecsdedup';
	const EXCHANGEDBSOURCE		= 'exchangedbsource';
	const ACCELERATOR			= 'accelerator';
	const GRANULARRESTORE1		= 'granularrestore1';
	const DISCOVERYLIFETIME		= 'discoverylifetime';
	const FASTBACKUP			= 'fastbackup';
	const KEY					= 'key';
	const RES					= 'res';
	const POOL					= 'pool';
	const FOE					= 'foe';
	const SHAREGROUP			= 'sharegroup';
	const DATACLASSIFICATION	= 'dataclassification';
	const HYPERVSERVER			= 'hypervserver';
	const NAMES					= 'names';
	const BCMD					= 'bcmd';
	const RCMD					= 'rcmd';
	const APPLICATIONDEFINED	= 'applicationdefined';
	const ORABKUPDATAFILEARGS	= 'orabkupdatafileargs';
	const ORABKUPARCHLOGARGS	= 'orabkuparchlogargs';
	const INCLUDES				= 'include';

	private $policies 			= array( );
	private $_clients			= NULL;
	private $_schedules			= NULL;
	private $clients			= array( );
	private $schedules			= array( );
	
	public function policies( $field = NULL, $value = NULL) { return _arr( $this->policies, func_get_args( ) ); }
	public function _clients( $value = NULL ) { return _var( $this->_clients, func_get_args( ) ); }
	public function _schedules( $value = NULL ) { return _var( $this->_schedules, func_get_args( ) ); }
	public function clients( $field = NULL, $value = NULL) { return _arr( $this->clients, func_get_args( ) ); }
	public function schedules( $field = NULL, $value = NULL) { return _arr( $this->schedules, func_get_args( ) ); }
	
	protected function parse_split( $split ) {
		$match = array( );
		foreach( explode( PHP_EOL, $split ) as $line ) {
			$line = str_replace( '*NULL*', '', $line );
			$line = str_replace( '*ANY*', 'ANY', $line );
			$value = explode( ' ', $line );
			$field = array_shift( $value );
			count( $value ) == 1 && $value = $value[ 0 ];
			if ( substr( $field, 0, 5 ) == 'SCHED' and strlen( $field ) == 5 ) {
				$match[ $field ][ ][ $field ] = $value;
				$index = count( $match[ $field ] ) - 1;
			}
			if ( substr( $field, 0, 5 ) == 'SCHED' and strlen( $field ) > 5 ) {
				$match[ 'SCHED' ][ $index ][ $field ] = $value;
			}
			if ( substr( $field, 0, 5 ) != 'SCHED' ) {
				$match[ $field ][ ] = $value;
			}
		}
		foreach( $match as $key => $value )
			is_array( $value ) && count( $value ) == 1 && $match[ $key ] = empty( $value[ 0 ] ) ? NULL : $value[ 0 ];
		$row = array( );
		foreach ( $this->fields( ) as $name => $type ) {
			$row[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
		}
		list(
			$row[ static::POLICYNAME ],
			$row[ static::INTERNALNAME ],
			$row[ static::OPTIONS ],
			$row[ static::PROTOCOLVERSION ],
			$row[ static::TIMEZONEOFFSET ],
			$row[ static::AUDITREASON ]
			) = $match[ 'CLASS' ];
		list(
			$row[ static::POLICYTYPE ],
			$row[ static::FOLLOWNFSMOUNT ],
			$row[ static::CLIENTCOMPRESS ],
			$row[ static::JOBPRIORITY ],
			$row[ static::PROXYCLIENT ],
			$row[ static::CLIENTENCRYPT ],
			$row[ static::DR ],
			$row[ static::MAXJOBSPERCLIENT ],
			$row[ static::CROSSMOUNTPOINTS ],
			$row[ static::MAXFRAGSIZE ],
			$row[ static::ACTIVE ],
			$row[ static::TIR ],
			$row[ static::UNUSED ],
			$row[ static::BLOCKLEVELINCREMENTALS ],
			$row[ static::INDIVIDUALFILERESTORE ],
			$row[ static::STREAMING ],
			$row[ static::FROZENIMAGE ],
			$row[ static::BACKUPCOPY ],
			$row[ static::EFFECTIVEDATE ],
			$row[ static::CLASSID ],
			$row[ static::BACKUPCOPIES ],
			$row[ static::CHECKPOINTS ],
			$row[ static::CHECKPOINTINTERVAL ],
			$row[ static::UNUSED ],
			$row[ static::INSTANTRECOVERY ],
			$row[ static::OFFHOSTBACKUP ],
			$row[ static::ALTERNATECLIENT ],
			$row[ static::DATAMOVER ],
			$row[ static::DATAMOVERTYPE ],
			$row[ static::BMR ],
			$row[ static::LIFECYCLE ],
			$row[ static::GRANULARRESTORE ],
			$row[ static::JOBSUBTYPE ],
			$row[ static::VM ],
			$row[ static::IGNORECSDEDUP ],
			$row[ static::EXCHANGEDBSOURCE ],
			$row[ static::ACCELERATOR ],
			$row[ static::GRANULARRESTORE1 ],
			$row[ static::DISCOVERYLIFETIME ],
			$row[ static::FASTBACKUP ]
			) = $match[ 'INFO' ];
		$row[ static::KEY ] = $match[ 'KEY' ];
		$row[ static::RES ] = empty( $match[ 'RES' ] ) ? '' : implode( ',', $match[ 'RES' ] );
		$row[ static::POOL ] = empty( $match[ 'POOL' ] ) ? '' : implode( ',', $match[ 'POOL' ] );
		$row[ static::FOE ] = empty( $match[ 'FOE' ] ) ? '' : implode( ',', $match[ 'FOE' ] );
		$row[ static::SHAREGROUP ] = $match[ 'SHAREGROUP' ];
		$row[ static::DATACLASSIFICATION ] = $match[ 'DATACLASSIFICATION' ];
		$row[ static::HYPERVSERVER ] =  empty( $match[ 'HYPERVSERVER' ] ) ? '' : $match[ 'HYPERVSERVER' ];
		$row[ static::NAMES ] = $match[ 'NAMES' ];
		$row[ static::BCMD ]= $match[ 'BCMD' ];
		$row[ static::RCMD ] = $match[ 'RCMD' ];
		$row[ static::APPLICATIONDEFINED ] = empty( $match[ 'APPLICATIONDEFINED' ] ) ? '' : $match[ 'APPLICATIONDEFINED' ];
		$row[ static::ORABKUPDATAFILEARGS ] = empty( $match[ 'ORABKUPDATAFILEARGS' ] ) ? '' : $match[ 'ORABKUPDATAFILEARGS' ];
		$row[ static::ORABKUPARCHLOGARGS ] = empty( $match[ 'ORABKUPARCHLOGARGS' ] ) ? '' : $match[ 'ORABKUPARCHLOGARGS' ];
		$include = empty( $match[ 'INCLUDE' ] ) ? '' : $match[ 'INCLUDE' ];
		if ( is_array( $include ) ) 
			$include = implode( ' ', array_map( function ( $e ) { return is_array( $e ) ? implode( ' ' , $e ) : $e; }, $include ) );
		$row[ static::INCLUDES ] = str_replace( "'", "\'", str_replace( '\\', '/', $include ) );
		unset( $match );
		foreach( $row as $key => $value ) {
			$this->fields( $key ) || $this->fields( $key, field::STRING );
			if ( is_array( $row[ $key ] ) ) {
				$row[ $key ] = serialize( $row[ $key ] );
			}
			$row[ $key ] = field::validate( $row[ $key ] );
		}
		return $row;
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->policies( $row[ static::POLICYNAME ], $row );
		$this->_clients( new bppllist_clients( ) )->parse( $this->lines( ) );
		$this->_schedules( new bppllist_schedules( ) )->parse( $this->lines( ) );
		$this->parsing_errors( 
			array_unique( 
				array_merge( $this->parsing_errors( ), $this->_clients( )->parsing_errors( ), $this->_schedules( )->parsing_errors( ) ) 
			)
		);
		$this->clients( $this->_clients( )->clients( ) );
		$this->schedules( $this->_schedules( )->schedules( ) );
	}
	
	public function sql( $table = NULL, $rows = NULL ) {
		$result = array_merge( parent::sql( $table, $rows ), $this->_clients( )->sql( get_class( $this->_clients( ) ), $rows ), $this->_schedules( )->sql( get_class( $this->_schedules( ) ), $rows ) );
		return array_filter( $result );
	}
}

class bppllist_clients extends bppllist_allpolicies {
	const POLICYNAME			= 'policyname';
	const CLIENTNAME			= 'name';
	const ARCHITECTURE 			= 'architecture';
	const OS					= 'os';
	const FIELD1				= 'field1';
	const FIELD2				= 'field2';
	const FIELD3				= 'field3';
	const FIELD4				= 'field4';

	private $clients 			= array( );

	public function clients( $field = NULL, $value = NULL) { return _arr( $this->clients, func_get_args( ) ); }

	protected function parse_split( $split ) {
		$match = array( );
		foreach( explode( PHP_EOL, $split ) as $line ) {
			$line = str_replace( '*NULL*', 'NULL', $line );
			$line = str_replace( '*ANY*', 'ANY', $line );
			$value = explode( ' ', $line );
			$field = array_shift( $value );
			count( $value ) == 1 && $value = $value[ 0 ];
			if ( substr( $field, 0, 5 ) == 'SCHED' and strlen( $field ) == 5 ) {
				$match[ $field ][ ][ $field ] = $value;
				$index = count( $match[ $field ] ) - 1;
			}
			if ( substr( $field, 0, 5 ) == 'SCHED' and strlen( $field ) > 5 ) {
				$match[ 'SCHED' ][ $index ][ $field ] = $value;
			}
			if ( substr( $field, 0, 5 ) != 'SCHED' ) {
				$match[ $field ][ ] = $value;
			}
		}
		foreach( $match as $key => $value )
			is_array( $value ) && count( $value ) == 1 && $match[ $key ] = empty( $value[ 0 ] ) ? NULL : $value[ 0 ];
		if( empty( $match[ 'CLIENT' ] ) ) return array( );
		$this->add_fields( static::POLICYNAME, $match[ 'CLASS' ][ 0 ] );
		!is_array( $match[ 'CLIENT' ][ 0 ] ) && $match[ 'CLIENT' ] = array( $match[ 'CLIENT' ] );
		$rows = array( );
		foreach( $match[ 'CLIENT' ] as $client ) {
			$row = array( );
			foreach ( $this->fields( ) as $name => $type ) {
				$row[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
			}
			$row[ static::POLICYNAME ] = $match[ 'CLASS' ][ 0 ];
			list(
				$row[ static::CLIENTNAME ],
				$row[ static::ARCHITECTURE ],
				$row[ static::OS ],
				$row[ static::FIELD1 ],
				$row[ static::FIELD2 ],
				$row[ static::FIELD3 ],
				$row[ static::FIELD4 ]
				) = $client;
			foreach( $row as $key => $value ) {
				$this->fields( $key ) || $this->fields( $key, field::STRING );
				if ( is_array( $row[ $key ] ) ) {
					$row[ $key ] = serialize( $row[ $key ] );
				}
				$row[ $key ] = field::validate( $row[ $key ] );
			}
			$rows[ ] = $row;
		}
		unset( $match );
		return $rows;
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->clients( $row[ static::CLIENTNAME ], $row );
	}
}

class bppllist_schedules extends bppllist_allpolicies {
	const POLICYNAME			= 'policyname';
	const SCHEDULENAME			= 'name';
	const BACKUPTYPE			= 'backuptype';
	const MULTIPLEXINGCOPIES	= 'multiplexingcopies';
	const FREQUENCY				= 'frequency';
	const RETENTIONLEVEL		= 'retentionlevel';
	const RESERVED1				= 'reserved1';
	const RESERVED2				= 'reserved2';
	const RESERVED3				= 'reserved3';
	const ALTERNATEREADSERVER	= 'alternatereadserver';
	const MAXFRAGMENTSIZE		= 'maxfragmentsize';
	const CALENDAR				= 'calendar';
	const COPIES				= 'copies';
	const FOE					= 'foe';
	const SYNTHETIC				= 'synthetic';
	const PFIFASTRECOVER		= 'pfifastrecover';
	const PRIORITY				= 'priority';
	const STORAGESERVICE		= 'storageservice';
	const CHECKSUMDETECTION		= 'checksumdetection';
	const CALDATES				= 'caldates';
	const CALRETRIES			= 'calretries';
	const CALDAYOFWEEK			= 'caldayofweek';
	const WIN_SUN_START			= 'win_sun_start';
	const WIN_SUN_DURATION		= 'win_sun_duration';
	const WIN_MON_START			= 'win_mon_start';
	const WIN_MON_DURATION		= 'win_mon_duration';
	const WIN_TUE_START			= 'win_tue_start';
	const WIN_TUE_DURATION		= 'win_tue_duration';
	const WIN_WED_START			= 'win_wed_start';
	const WIN_WED_DURATION		= 'win_wed_duration';
	const WIN_THU_START			= 'win_thu_start';
	const WIN_THU_DURATION		= 'win_thu_duration';
	const WIN_FRI_START			= 'win_fri_start';
	const WIN_FRI_DURATION		= 'win_fri_duration';
	const WIN_SAT_START			= 'win_sat_start';
	const WIN_SAT_DURATION		= 'win_sat_duration';
	const SCHEDRES				= 'schedres';
	const SCHEDPOOL				= 'schedpool';
	const SCHEDRL				= 'schedrl';
	const SCHEDFOE				= 'schedfoe';
	const SCHEDSG				= 'schedsg';

	private $schedules 			= array( );

	public function schedules( $field = NULL, $value = NULL) { return _arr( $this->schedules, func_get_args( ) ); }

	protected function parse_split( $split ) {
		$match = array( );
		foreach( explode( PHP_EOL, $split ) as $line ) {
			$line = str_replace( '*NULL*', 'NULL', $line );
			$line = str_replace( '*ANY*', 'ANY', $line );
			$value = explode( ' ', $line );
			$field = array_shift( $value );
			count( $value ) == 1 && $value = $value[ 0 ];
			if ( substr( $field, 0, 5 ) == 'SCHED' and strlen( $field ) == 5 ) {
				$match[ $field ][ ][ $field ] = $value;
				$index = count( $match[ $field ] ) - 1;
			}
			if ( substr( $field, 0, 5 ) == 'SCHED' and strlen( $field ) > 5 ) {
				$match[ 'SCHED' ][ $index ][ $field ] = $value;
			}
			if ( substr( $field, 0, 5 ) != 'SCHED' ) {
				$match[ $field ][ ] = $value;
			}
		}
		foreach( $match as $key => $value )
			is_array( $value ) && count( $value ) == 1 && $match[ $key ] = empty( $value[ 0 ] ) ? NULL : $value[ 0 ];
		if ( empty( $match[ 'SCHED' ] ) ) return array( );
		$this->add_fields( static::POLICYNAME, $match[ 'CLASS' ][ 0 ] );
		empty( $match[ 'SCHED' ][ 0 ] ) && $match[ 'SCHED' ] = array( $match[ 'SCHED' ] );
		$rows = array( );
		foreach( $match[ 'SCHED' ] as $sched ) {
			$row = array( );
			foreach ( $this->fields( ) as $name => $type ) {
				$row[ $name ] = field::validate( isset( $match[ $name ] ) ? $match[ $name ] : $this->add_fields( $name ), $type );
			}
			$row[ static::POLICYNAME ] = $match[ 'CLASS' ][ 0 ];
			list(
				$row[ static::SCHEDULENAME ],
				$row[ static::BACKUPTYPE ],
				$row[ static::MULTIPLEXINGCOPIES ],
				$row[ static::FREQUENCY ],
				$row[ static::RETENTIONLEVEL ],
				$row[ static::RESERVED1 ],
				$row[ static::RESERVED2 ],
				$row[ static::RESERVED3 ],
				$row[ static::ALTERNATEREADSERVER ],
				$row[ static::MAXFRAGMENTSIZE ],
				$row[ static::CALENDAR ],
				$row[ static::COPIES ],
				$row[ static::FOE ],
				$row[ static::SYNTHETIC ],
				$row[ static::PFIFASTRECOVER ],
				$row[ static::PRIORITY ],
				$row[ static::STORAGESERVICE ],
				$row[ static::CHECKSUMDETECTION ]
				) = $sched[ 'SCHED' ];
			$row[ static::CALDATES ] = empty( $sched[ 'SCHEDCALDATES' ] ) ? '' : implode( ',', $sched[ 'SCHEDCALDATES' ] );
			$row[ static::CALRETRIES ] = empty( $sched[ 'SCHEDCALENDAR' ] ) ? '' : $sched[ 'SCHEDCALENDAR' ];
			$row[ static::CALDAYOFWEEK ] = empty( $sched[ 'SCHEDCALDAYOWEEK' ] ) ? '' : $sched[ 'SCHEDCALDAYOWEEK' ];
			list(
				$row[ static::WIN_SUN_START ],
				$row[ static::WIN_SUN_DURATION ],
				$row[ static::WIN_MON_START ],
				$row[ static::WIN_MON_DURATION ],
				$row[ static::WIN_TUE_START ],
				$row[ static::WIN_TUE_DURATION ],
				$row[ static::WIN_WED_START ],
				$row[ static::WIN_WED_DURATION ],
				$row[ static::WIN_THU_START ],
				$row[ static::WIN_THU_DURATION ],
				$row[ static::WIN_FRI_START ],
				$row[ static::WIN_FRI_DURATION ],
				$row[ static::WIN_SAT_START ],
				$row[ static::WIN_SAT_DURATION ]
				)= $sched[ 'SCHEDWIN' ];
			$row[ static::SCHEDRES ] = implode( ',', $sched[ 'SCHEDRES' ] );
			$row[ static::SCHEDPOOL ] = implode( ',', $sched[ 'SCHEDPOOL' ] );
			$row[ static::SCHEDRL ] = implode( ',', $sched[ 'SCHEDRL' ] );
			$row[ static::SCHEDFOE ] = implode( ',', $sched[ 'SCHEDFOE' ] );
			$row[ static::SCHEDSG ] = implode( ',', $sched[ 'SCHEDSG' ] );
			foreach( $row as $key => $value ) {
				$this->fields( $key ) || $this->fields( $key, field::STRING );
				if ( is_array( $row[ $key ] ) ) {
					$row[ $key ] = serialize( $row[ $key ] );
				}
				$row[ $key ] = field::validate( $row[ $key ] );
			}
			$rows[ ] = $row;
		}
		unset( $match );
		return $rows;
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->schedules( $row[ static::SCHEDULENAME ], $row );
	}
}

### VAULT_XML

class vault_xml extends text {
	const FILENAME					= 'vault.xml';
	const FILE_NOT_EXISTS_EXCEPTION	= 'VAULT: File "%s" does not exist.';
	const SIMPLEXML2ARRAY_EXCEPTION	= 'VAULT: unhandled "%s"\'s child item "%s".';
	const NO_ITEMS_EXCEPTION 		= 'VAULT: no "%s" child item found.';
	const MORE_ITEMS_EXCEPTION		= 'VAULT: more than %s "%s" child items found (%s).';
	const MISSING_ITEMS_EXCEPTION	= 'VAULT: items(s) missing in "%s": %s';
	private $home					= NULL;
	private $updated				= '';
	
	public function home( $value = NULL ) { return _var( $this->home, func_get_args( ) ); }
	public function updated( $value = NULL ) { return _var( $this->updated, func_get_args( ) ); }
	
	public function __construct( $home ) {
		if ( !file_exists( $home ) ) throw new exception( sprintf( static::FILE_NOT_EXISTS_EXCEPTION, $home ) );
		$this->home( $home );
		$this->setup( );
		$this->parse( );
	}
	
	public function setup( ) {
		$this->updated( date( 'Y-m-d H:i:s' ) );
		$fields = array( );
		$fields[ 'VAULT_MGR' ] = array( 'VaultConfigVersion', 'ROBOT', 'VAULT_PREFERENCES' );
		$fields[ 'VAULT_PREFERENCES' ] = array( 'EjectNotificationEmail','LastMod','MGOImageSelectDays','NotificationEmail','SortOnExpiryDate','RETENTION_MAP','REPORTS', 'ALIASES' );
		$fields[ 'ALIASES' ] = array( );
		$fields[ 'RETENTION_MAP' ] = array( 'RETMAP_ITEM' );
		$fields[ 'RETMAP_ITEM' ] = array( 'NEW','OLD' );
		$fields[ 'ROBOT' ] = array( 'EjectNotificationEmail','Id','LastMod','Name','RobotNumber','RobotType','RoboticControlHost','UseVaultPrefENE','VAULT' );
		$fields[ 'VAULT' ] = array( 'CustomerID','Id','LastMod','Name','OffsiteVolumeGroup','RobotVolumeGroup','VaultContainers','VaultSeed','Vendor','MAP','RETENTION_MAP','PROFILE' );
		$fields[ 'MAP' ] = array( 'RETENTION_MAP' );
		$fields[ 'PROFILE' ] = array( 'Id','LastMod','Name','SELECTION','DUPLICATION','CATALOG_BACKUP','EJECT','REPORTS_SETTINGS' );
		$fields[ 'SELECTION' ] = array( 'EndDay','EndHour','StartDay','StartHour','IMAGE_PROPERTIES_FILTERS','IMAGE_LOCATION_FILTERS' );
		$fields[ 'IMAGE_PROPERTIES_FILTERS' ] = array( 'Enabled','CLIENT_FILTER','BACKUP_TYPE_FILTER','MEDIA_SERVER_FILTER','CLASS_FILTER','RETENTION_LEVEL_FILTER','SCHEDULE_FILTER' );
		$fields[ 'CLIENT_FILTER' ] = array( 'InclExclOpt','CLIENT' );
		$fields[ 'CLIENT' ] = array( 0 );
		$fields[ 'BACKUP_TYPE_FILTER' ] = array( 'InclExclOpt', 'BACKUP_TYPE' );
		$fields[ 'BACKUP_TYPE' ] = array( );
		$fields[ 'MEDIA_SERVER_FILTER' ] = array( 'InclExclOpt' );
		$fields[ 'CLASS_FILTER' ] = array( 'InclExclOpt','CLASS' );
		$fields[ 'CLASS' ] = array( 0 );
		$fields[ 'SCHEDULE_FILTER' ] = array( 'InclExclOpt','SCHEDULE' );
		$fields[ 'SCHEDULE' ] = array( 0 );
		$fields[ 'RETENTION_LEVEL_FILTER' ] = array( 'InclExclOpt' );
		$fields[ 'IMAGE_LOCATION_FILTERS' ] = array( 'Enabled','SOURCE_VOL_GROUP_FILTER','VOLUME_POOL_FILTER','BASIC_DISK_FILTER','DISK_GROUP_FILTER' );
		$fields[ 'SOURCE_VOL_GROUP_FILTER' ] = array( 'InclExclOpt' );
		$fields[ 'VOLUME_POOL_FILTER' ] = array( 'InclExclOpt' );
		$fields[ 'BASIC_DISK_FILTER' ] = array( 'InclExclOpt' );
		$fields[ 'DISK_GROUP_FILTER' ] = array( 'InclExclOpt' );
		$fields[ 'DUPLICATION' ] = array( 'DupPriority','Multiplex','SharedRobots','Skip','SortOrder','DUPLICATION_ITEM' );
		$fields[ 'DUPLICATION_ITEM' ] = array( 'AltReadHost','BackupServer','ReadDrives','WriteDrives','COPY' );
		$fields[ 'COPY' ] = array( 'Fail','Primary','Retention','ShareGroup','StgUnit','VolPool' );
		$fields[ 'CATALOG_BACKUP' ] = array( 'Skip' );
		$fields[ 'EJECT' ] = array( 'EjectMode','EjectNotificationEmail','Skip','Suspend','SuspendMode','UseRbtorVaultPrefENE','POOL' );
		$fields[ 'POOL' ] = array( 0 );
		$fields[ 'REPORTS_SETTINGS' ] = array( 'IMFile','Mode','ReportsHeader','UseGlobalRptsDist','REPORTS' );
		$fields[ 'REPORTS' ] = array( 'REPORT' );
		$fields[ 'REPORT' ] = array( 'Email','End','File','Option','Printer','RptIdx','Start','Title' );
		$this->fields( $fields );
		$xml = simplexml_load_file( $this->home( ) .  DIRECTORY_SEPARATOR . static::FILENAME );
		$this->rows( array( 'VAULT_MGR' => array( $this->simplexml2array( $xml ) ) ) );
	}
	
	private function simplexml2array( $object ) {
		$keys = array_keys( $this->fields( ) );
		$result = array( );
		foreach( $object->attributes( ) as $a => $b) {
			if ( is_object( $b ) ) $b = $b->__toString( );
			$result[ $a ] = $b;
		}
		$value = trim( $object->__toString( ) );
		if ( !empty( $value ) ) $result[ ] = $value;
		foreach( $object as $child ) {
			$name = $child->getName( );
			if ( in_array( $name, $keys ) ) {
				$result[ $name ][ ] = $this->simplexml2array( $child );
			} else {
				throw new exception( sprintf( static::SIMPLEXML2ARRAY_EXCEPTION, $object->getName( ), $name ) );
			}
		}
		return $result;
	}
	
	public function parse( ) {
		foreach( $this->items( $this->rows( ), 'VAULT_MGR', 1 ) as $vault_mgr )
			foreach( $this->items( $vault_mgr, 'ROBOT', 0 ) as $robot )
				foreach( $this->items( $robot, 'VAULT', 0 ) as $vault ) try {
					foreach( $this->items( $vault, 'PROFILE', 0 ) as $profile ) {
						foreach( $this->items( $profile, 'SELECTION', 1 ) as $selection ) {
							foreach( $this->items( $selection, 'IMAGE_PROPERTIES_FILTERS', 1 ) as $ipf ) {
								foreach ( $this->items( $ipf, 'CLIENT_FILTER', 1 ) as $clientfilter )
									foreach ( $this->items( $clientfilter, 'CLIENT' ) as $client )
										foreach ( $this->items( $ipf, 'BACKUP_TYPE_FILTER', 1 ) as $btf );
										foreach ( $this->items( $ipf, 'MEDIA_SERVER_FILTER', 1 ) as $mediaserverfilter );
										foreach ( $this->items( $ipf, 'CLASS_FILTER', 1 ) as $classfilter )
											foreach ( $this->items( $classfilter, 'CLASS' ) as $class )
												foreach ( $this->items( $ipf, 'SCHEDULE_FILTER', 1 ) as $schedulefilter )
													foreach ( $this->items( $schedulefilter, 'SCHEDULE' ) as $schedule )
														foreach ( $this->items( $ipf, 'RETENTION_LEVEL_FILTER', 1 ) as $retentionlevelfilter );
							}
							foreach( $this->items( $selection, 'IMAGE_LOCATION_FILTERS', 1 ) as $ilf ) {
								foreach ( $this->items( $ilf, 'SOURCE_VOL_GROUP_FILTER', 1 ) as $sourcevolgroupfilter );
								foreach ( $this->items( $ilf, 'VOLUME_POOL_FILTER', 1 ) as $volumepoolfilter );
								foreach ( $this->items( $ilf, 'BASIC_DISK_FILTER', 1 ) as $basicdiskfilter );
								foreach ( $this->items( $ilf, 'DISK_GROUP_FILTER', 1 ) as $diskgroupfilter );
							}
						}
						foreach( $this->items( $profile, 'DUPLICATION', 1 ) as $duplication )
							foreach( $this->items( $duplication, 'DUPLICATION_ITEM', 1 ) as $duplicationitem )
								foreach( $this->items( $duplicationitem, 'COPY', 1 ) as $copy );
								foreach( $this->items( $profile, 'CATALOG_BACKUP', 1 ) as $catalogbackup );
								foreach( $this->items( $profile, 'EJECT', 1 ) as $eject )
									foreach( $this->items( $eject, 'POOL' ) as $pool );
									foreach( $this->items( $profile, 'REPORTS_SETTINGS', 1 ) as $reportssettings )
										foreach( $this->items( $reportssettings, 'REPORTS', 1 ) as $reports )
											foreach( $this->items( $reports, 'REPORT' ) as $report );
					}
					foreach( $this->items( $vault, 'MAP', 0 ) as $map );
				} catch ( exception $e ) {
					display( $e->getmessage( ) );
				}
		foreach( $this->items( $vault_mgr, 'VAULT_PREFERENCES', 0 ) as $preferences ) {
			foreach( $this->items( $preferences, 'RETENTION_MAP', 1 ) as $map )
				foreach( $this->items( $map, 'RETMAP_ITEM' ) as $item );
				foreach( $this->items( $preferences, 'REPORTS', 1 ) as $reports )
					foreach( $this->items( $reports, 'REPORT' ) as $report );
		}
	}

	private function items( $source, $object, $value = NULL ) {
		$result =  empty( $source[ $object ] ) ? array( ) : $source[ $object ];
		$count = count( $result );
		if ( $value === 0 and $count == 0 ) {
			throw new exception( sprintf( static::NO_ITEMS_EXCEPTION, $object ) );
		}
		if ( $value > 0 and $count > $value ) {
			throw new exception( sprintf( static::MORE_ITEMS_EXCEPTION, $value, $object ,$count ) );
		}
		foreach( $result as $item ) {
			$diff = array_diff( array_keys( $item ), $this->fields( $object ) );
			if ( count( $diff ) > 0 ) {
				throw new exception( sprintf( static::MISSING_ITEMS_EXCEPTION, $object, print_r( $diff, true) ) );
			}
		}
		return $result;
	}

	public function execute( ) {
		return $this;
	}
	
	public function SQL( $table = NULL, $rows = NULL ) {
		$masterserver = nbu( )->masterserver( );
		$vault_sql = 'replace into vault_xml (`masterserver`,`robot_id`,`robot_lastmod`,`robot_name`,`robotnumber`,`robottype`,`roboticcontrolhost`,`usevaultprefene`,`robot_ene`,
	`customerid`,`vault_id`,`vault_lastmod`,`vault_name`,`offsitevolumegroup`,`robotvolumegroup`,`vaultcontainers`,`vaultseed`,`vendor`,`profile_id`,`profile_lastmod`,`profile_name`,`endday`,`endhour`,`startday`,`starthour`,
	`ipf_enabled`,`clientfilter`,`backuptypefilter`,`mediaserverfilter`,`classfilter`,`schedulefilter`,`retentionlevelfilter`,`ilf_enabled`,`sourcevolgroupfilter`,`volumepoolfilter`,`basicdiskfilter`,`diskgroupfilter`,
	`duplication_skip`,`duppriority`,`multiplex`,`sharedrobots`,`sortorder`,`altreadhost`,`backupserver`,`readdrives`,`writedrives`,`fail`,`primary`,`retention`,`sharegroup`,`stgunit`,`volpool`,`catalogbackup_skip`,
	`eject_skip`,`ejectmode`,`eject_ene`,`suspend`,`suspendmode`,`userbtorvaultprefene`,`imfile`,`mode`,`useglobalrptsdist`,`updated`,`obsoleted`) values ';
		$vault_item_sql = 'replace into vault_item_xml (`masterserver`,`profile`,`type`,`value`,`updated`,`obsoleted`) values ';
		foreach( $this->items( $this->rows( ), 'VAULT_MGR', 1 ) as $vault_mgr )
			foreach( $this->items( $vault_mgr, 'ROBOT', 0 ) as $robot )
				foreach( $this->items( $robot, 'VAULT', 0 ) as $vault ) try {
					foreach( $this->items( $vault, 'PROFILE', 0 ) as $profile ) {
						foreach( $this->items( $profile, 'SELECTION', 1 ) as $selection ) {
							foreach( $this->items( $selection, 'IMAGE_PROPERTIES_FILTERS', 1 ) as $ipf ) {
								foreach ( $this->items( $ipf, 'CLIENT_FILTER', 1 ) as $clientfilter )
									foreach ( $this->items( $clientfilter, 'CLIENT' ) as $client )
										$vault_item_sql .= sprintf( '("%s","%s","%s","%s","%s",null)', $masterserver, $profile[ 'Name' ], 'CLIENT', $client[ 0 ], $this->updated( ) ) . ',' . PHP_EOL;
								foreach ( $this->items( $ipf, 'BACKUP_TYPE_FILTER', 1 ) as $btf );
								foreach ( $this->items( $ipf, 'MEDIA_SERVER_FILTER', 1 ) as $mediaserverfilter );
								foreach ( $this->items( $ipf, 'CLASS_FILTER', 1 ) as $classfilter )
									foreach ( $this->items( $classfilter, 'CLASS' ) as $class )
										$vault_item_sql .= sprintf( '("%s","%s","%s","%s","%s",null)', $masterserver, $profile[ 'Name' ], 'CLASS', $class[ 0 ], $this->updated( ) ) . ',' . PHP_EOL;
								foreach ( $this->items( $ipf, 'SCHEDULE_FILTER', 1 ) as $schedulefilter )
									foreach ( $this->items( $schedulefilter, 'SCHEDULE' ) as $schedule )
										$vault_item_sql .= sprintf( '("%s","%s","%s","%s","%s",null)', $masterserver, $profile[ 'Name' ], 'SCHEDULE', $schedule[ 0 ], $this->updated( ) ) . ',' . PHP_EOL;
									foreach ( $this->items( $ipf, 'RETENTION_LEVEL_FILTER', 1 ) as $retentionlevelfilter );
							}
							foreach( $this->items( $selection, 'IMAGE_LOCATION_FILTERS', 1 ) as $ilf ) {
								foreach ( $this->items( $ilf, 'SOURCE_VOL_GROUP_FILTER', 1 ) as $sourcevolgroupfilter );
								foreach ( $this->items( $ilf, 'VOLUME_POOL_FILTER', 1 ) as $volumepoolfilter );
								foreach ( $this->items( $ilf, 'BASIC_DISK_FILTER', 1 ) as $basicdiskfilter );
								foreach ( $this->items( $ilf, 'DISK_GROUP_FILTER', 1 ) as $diskgroupfilter );
							}
							
						}
						foreach( $this->items( $profile, 'DUPLICATION', 1 ) as $duplication )
							foreach( $this->items( $duplication, 'DUPLICATION_ITEM', 1 ) as $duplicationitem )
								foreach( $this->items( $duplicationitem, 'COPY', 1 ) as $copy );
								foreach( $this->items( $profile, 'CATALOG_BACKUP', 1 ) as $catalogbackup );
								foreach( $this->items( $profile, 'EJECT', 1 ) as $eject )
									foreach( $this->items( $eject, 'POOL' ) as $pool );
								foreach( $this->items( $profile, 'REPORTS_SETTINGS', 1 ) as $reportssettings )
									foreach( $this->items( $reportssettings, 'REPORTS', 1 ) as $reports )
										foreach( $this->items( $reports, 'REPORT' ) as $report );
								$row = array( );
								$row[ 'masterserver' ] = sprintf( '"%s"', $masterserver );
								
								$row[ 'robot_id' ] = sprintf( '%s', $robot[ 'Id' ] );
								$row[ 'robot_lastmod' ] = sprintf( '%s', $robot[ 'LastMod' ] );
								$row[ 'robot_name' ] = sprintf( '"%s"', $robot[ 'Name' ] );
								$row[ 'robotnumber' ] = sprintf( '%s', $robot[ 'RobotNumber' ] );
								$row[ 'robottype' ] = sprintf( '"%s"', $robot[ 'RobotType' ] );
								$row[ 'roboticcontrolhost' ] = sprintf( '"%s"', $robot[ 'RoboticControlHost' ] );
								$row[ 'usevaultprefene' ] = sprintf( '"%s"', $robot[ 'UseVaultPrefENE' ] );
								$row[ 'robot_ene' ] = sprintf( 'nullif("%s","")', isset( $robot[ 'EjectNotificationEmail' ]) ? $robot[ 'EjectNotificationEmail' ] : '' );
								
								$row[ 'customerid' ] = sprintf( '"%s"', $vault[ 'CustomerID' ] );
								$row[ 'vault_id' ] = sprintf( '%s', $vault[ 'Id' ] );
								$row[ 'vault_lastmod' ] = sprintf( '%s', $vault[ 'LastMod' ] );
								$row[ 'vault_name' ] = sprintf( '"%s"', $vault[ 'Name' ] );
								$row[ 'offsitevolumegroup' ] = sprintf( '"%s"', $vault[ 'OffsiteVolumeGroup' ] );
								$row[ 'robotvolumegroup' ] = sprintf( '"%s"', $vault[ 'RobotVolumeGroup' ] );
								$row[ 'vaultcontainers' ] = sprintf( '"%s"', $vault[ 'VaultContainers' ] );
								$row[ 'vaultseed' ] = sprintf( '%s', $vault[ 'VaultSeed' ] );
								$row[ 'vendor' ] = sprintf( '"%s"', $vault[ 'Vendor' ] );
								
								$row[ 'profile_id' ] = sprintf( '%s', $profile[ 'Id' ] );
								$row[ 'profile_lastmod' ] = sprintf( '%s', $profile[ 'LastMod' ] );
								$row[ 'profile_name' ] = sprintf( '"%s"', $profile[ 'Name' ] );
								
								$row[ 'endday' ] = sprintf( '%s', $selection[ 'EndDay' ] );
								$row[ 'endhour' ] = sprintf( '%s', $selection[ 'EndHour' ] );
								$row[ 'startday' ] = sprintf( '%s', $selection[ 'StartDay' ] );
								$row[ 'starthour' ] = sprintf( '%s', $selection[ 'StartHour' ] );
								
								$row[ 'ipf_enabled' ] = sprintf( '"%s"', $ipf[ 'Enabled' ] );
								$row[ 'clientfilter' ] = sprintf( 'nullif("%s","")', isset( $clientfilter[ 'InclExclOpt' ] ) ? $clientfilter[ 'InclExclOpt' ] : '' );
								$row[ 'backuptypefilter' ] = sprintf( 'nullif("%s","")', isset( $backuptypefilter[ 'InclExclOpt' ]) ? $backuptypefilter[ 'InclExclOpt' ] : '' );
								$row[ 'mediaserverfilter' ] = sprintf( 'nullif("%s","")', isset( $mediaserverfilter[ 'InclExclOpt' ]) ? $mediaserverfilter[ 'InclExclOpt' ] : '' );
								$row[ 'classfilter' ] = sprintf( 'nullif("%s","")', isset( $classfilter[ 'InclExclOpt' ] ) ? $classfilter[ 'InclExclOpt' ] : '' );
								$row[ 'schedulefilter' ] = sprintf( 'nullif("%s","")', isset( $schedulefilter[ 'InclExclOpt' ] ) ? $schedulefilter[ 'InclExclOpt' ] : '' );
								$row[ 'retentionlevelfilter' ] = sprintf( 'nullif("%s","")', isset( $retentionlevelfilter[ 'InclExclOpt' ] ) ? $retentionlevelfilter[ 'InclExclOpt' ] : '' );
								
								$row[ 'ilf_enabled' ] = sprintf( '"%s"', $ilf[ 'Enabled' ] );
								$row[ 'sourcevolgroupfilter' ] = sprintf( 'nullif("%s","")', isset( $sourcevolgroupfilter[ 'InclExclOpt' ] ) ? $sourcevolgroupfilter[ 'InclExclOpt' ] : '' );
								$row[ 'volumepoolfilter' ] = sprintf( 'nullif("%s","")', isset( $volumepoolfilter[ 'InclExclOpt' ] ) ? $volumepoolfilter[ 'InclExclOpt' ] : '' );
								$row[ 'basicdiskfilter' ] = sprintf( 'nullif("%s","")', isset( $basicdiskfilter[ 'InclExclOpt' ] ) ? $basicdiskfilter[ 'InclExclOpt' ] : '' );
								$row[ 'diskgroupfilter' ] = sprintf( 'nullif("%s","")', isset( $diskgroupfilter[ 'InclExclOpt' ] ) ? $diskgroupfilter[ 'InclExclOpt' ] : '' );
								
								$row[ 'duplication_skip' ] = sprintf( '"%s"', $duplication[ 'Skip' ] );
								$row[ 'duppriority' ] = sprintf( 'nullif("%s","")', isset( $duplication[ 'DupPriority' ] ) ? $duplication[ 'DupPriority' ] : '' );
								$row[ 'multiplex' ] = sprintf( 'nullif("%s","")', isset( $duplication[ 'Multiplex' ] ) ? $duplication[ 'Multiplex' ] : '' );
								$row[ 'sharedrobots' ] = sprintf( 'nullif("%s","")', isset( $duplication[ 'SharedRobots' ] ) ? $duplication[ 'SharedRobots' ]: '' );
								$row[ 'sortorder' ] = sprintf( 'nullif("%s","")', isset( $duplication[ 'SortOrder' ] ) ? $duplication[ 'SortOrder' ] : '' );
								$row[ 'altreadhost' ] = sprintf( 'nullif("%s","")', isset( $duplicationitem[ 'AltReadHost' ] ) ? $duplicationitem[ 'AltReadHost' ] : '' );
								$row[ 'backupserver' ] = sprintf( 'nullif("%s","")', isset( $duplicationitem[ 'BackupServer' ] ) ? $duplicationitem[ 'BackupServer' ] : '' );
								$row[ 'readdrives' ] = sprintf( 'nullif("%s","")', isset( $duplicationitem[ 'ReadDrives' ] ) ? $duplicationitem[ 'ReadDrives' ] : '' );
								$row[ 'writedrives' ] = sprintf( 'nullif("%s","")', isset( $duplicationitem[ 'WriteDrives' ] ) ? $duplicationitem[ 'WriteDrives' ] : '' );
								
								$row[ 'fail' ] = sprintf( 'nullif("%s","")', isset( $copy[ 'Fail' ] ) ? $copy[ 'Fail' ] : '' );
								$row[ 'primary' ] = sprintf( 'nullif("%s","")', isset( $copy[ 'Primary' ] ) ? $copy[ 'Primary' ] : '' );
								$row[ 'retention' ] = sprintf( 'nullif("%s","")', isset( $copy[ 'Retention' ] ) ? $copy[ 'Retention' ] : '' );
								$row[ 'sharegroup' ] = sprintf( 'nullif("%s","")', isset( $copy[ 'ShareGroup' ] ) ? $copy[ 'ShareGroup' ] : '' );
								$row[ 'stgunit' ] = sprintf( 'nullif("%s","")', isset( $copy[ 'StgUnit' ] ) ? $copy[ 'StgUnit' ] : '' );
								$row[ 'volpool' ] = sprintf( 'nullif("%s","")', isset( $copy[ 'VolPool' ] ) ? $copy[ 'VolPool' ] : '' );
								
								$row[ 'catalogbackup_skip' ] = sprintf( '"%s"', $catalogbackup[ 'Skip' ] );
								
								$row[ 'eject_skip' ] = sprintf( '"%s"', $eject[ 'Skip' ] );
								$row[ 'ejectmode' ] = sprintf( 'nullif("%s","")', isset( $eject[ 'EjectMode' ] ) ? $eject[ 'EjectMode' ] : '' );
								$row[ 'eject_ene' ] = sprintf( 'nullif("%s","")', isset( $eject[ 'EjectNotificationEmail' ] ) ? $eject[ 'EjectNotificationEmail' ] : '' );
								$row[ 'suspend' ] = sprintf( 'nullif("%s","")', isset( $eject[ 'Suspend' ] ) ? $eject[ 'Suspend' ] : '' );
								$row[ 'suspendmode' ] = sprintf( 'nullif("%s","")', isset( $eject[ 'SuspendMode' ] ) ? $eject[ 'SuspendMode' ] : '' );
								$row[ 'userbtorvaultprefene' ] = sprintf( 'nullif("%s","")', isset( $eject[ 'UseRbtorVaultPrefENE' ] ) ? $eject[ 'UseRbtorVaultPrefENE' ] : '' );
								
								$row[ 'imfile' ] = sprintf( 'nullif("%s","")', $reportssettings[ 'IMFile' ] );
								$row[ 'mode' ] = sprintf( 'nullif("%s","")', $reportssettings[ 'Mode' ] );
								$row[ 'useglobalrptsdist' ] = sprintf( 'nullif("%s","")', $reportssettings[ 'UseGlobalRptsDist' ] );
								$vault_sql .= sprintf( '(%s,"%s",null),', implode( ',', $row ), $this->updated( ) ) . PHP_EOL;
				}
			} catch ( exception $e ) {
				display( $e->getmessage( ) );
			}
			$vault_sql = substr_replace( $vault_sql, ';', strrpos( $vault_sql, ',' ), 1 );
			$vault_sql_cleanup = sprintf( "update vault_xml set obsoleted=updated where masterserver='%s' and obsoleted is null and updated<'%s';", $masterserver, $this->updated( ) );
			$vault_item_sql = substr_replace( $vault_item_sql, ';', strrpos( $vault_item_sql, ',' ), 1 );
			$vault_item_sql_cleanup = sprintf( "update vault_item_xml set obsoleted=updated where masterserver='%s' and obsoleted is null and updated<'%s';", $masterserver, $this->updated( ) );

			return array( $vault_sql, $vault_sql_cleanup, $vault_item_sql, $vault_item_sql_cleanup );
	}
}

### BPRETLEVEL

class bpretlevel extends nbu {
	const WIN_BIN	= 'admincmd\\bpretlevel';
	const ARGUMENTS		= '-L';
	const LEVEL			= 'level';
	const DAYS			= 'days';
	const SECONDS		= 'seconds';
	const PERIOD		= 'period';
	const DUMMY1		= 'dummy1';
	const DUMMY2		= 'dummy2';
	private $retlevel = array( );

	public function retlevel( $field = NULL, $value = NULL) { return _arr( $this->retlevel, func_get_args( ) ); }

	public static function pattern( ) {
		$pattern = array(
			text::P( static::LEVEL, text::NUMBER ),
			text::P( static::DAYS, text::NUMBER ),
			text::P( static::DUMMY1, '\(\s*' ) . 
			text::P( static::SECONDS, text::NUMBER ) .
			text::P( static::DUMMY2, '\)' ),
			text::P( static::PERIOD, text::ALL ) );
		return sprintf( static::PATTERN, implode( '\s+', $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->ignore_lines( NULL, '^(L|R|-)' );
		$this->remove_fields( array( static::DUMMY1, static::DUMMY2 ) );
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) {
			$this->retlevel( $row[ static::LEVEL ], $row );
		}
	}
}

### NBDEVQUERY

class nbdevquery_listdv_puredisk extends nbu {
	const WIN_BIN				= 'admincmd\\nbdevquery';
	const ARGUMENTS				= '-listdv -stype PureDisk -l';
 	const VERSION				= 'version';
	const DISKPOOL				= 'diskpool';
	const STYPE					= 'stype';
	const NAME					= 'name';
	const DISK_MEDIA_ID			= 'disk_media_id';
	const TOTAL_CAPACITY		= 'total_capacity';
	const FREE_SPACE			= 'free_space';
	const USED					= 'used';
	const NBU_STATE				= 'nbu_state';
	const STS_STATE				= 'sts_state';
	const NUM_WRITE_MOUNTS		= 'num_write_mounts';
	const ACTIVE_READ_MOUNTS	= 'active_read_streams';
	const ACTIVE_WRITE_STREAMS	= 'active_write_streams';
	const FLAGS					= 'flags';
	const NUM_READ_MOUNTS		= 'num_read_mounts';
	const UPDATED				= 'updated';
	const OBSOLETED				= 'obsoleted';
	
	private $updated			= '';
	private $devices			= array( );

	public function updated( $value = NULL ) { return _var( $this->updated, func_get_args( ) ); }
	public function devices( $field = NULL, $value = NULL) { return _arr( $this->devices, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array(
			text::P(static::VERSION, text::CSV ),
			text::P(static::DISKPOOL, text::CSV ),
			text::P(static::STYPE, text::CSV ),
			text::P(static::NAME, text::CSV ),
			text::P(static::DISK_MEDIA_ID, text::CSV ),
			text::P(static::TOTAL_CAPACITY, text::CSV ),
			text::P(static::FREE_SPACE, text::CSV ),
			text::P(static::USED, text::CSV ),
			text::P(static::NBU_STATE, text::CSV ),
			text::P(static::STS_STATE, text::CSV ),
			text::P(static::NUM_WRITE_MOUNTS, text::CSV ),
			text::P(static::ACTIVE_READ_MOUNTS, text::CSV ),
			text::P(static::ACTIVE_WRITE_STREAMS, text::CSV ),
			text::P(static::FLAGS, text::CSV ),
			text::P(static::NUM_READ_MOUNTS, text::CSV )
		);
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->add_fields( static::UPDATED, $this->updated( date( 'Y-m-d H:i:s' ) ) );
		$this->add_fields( static::OBSOLETED, NULL );
	}

	protected function parse_split( $split ) {
		$split = str_replace( '*NULL*', '', $split );
		return parent::parse_split( $split );	
	}

	protected function parse_rows( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->devices( $row[ static::DISKPOOL ], $row );
	}

	public function sql( $table = NULL, $rows = NULL ) {
		$result = parent::sql( $table, $rows );
		$result[ ] = sprintf( "update %s set %s=%s where %s='%s' and %s is null and %s<'%s';", $table,
			static::OBSOLETED, static::UPDATED, 
			static::MASTERSERVER, nbu( )->masterserver( ), 
			static::OBSOLETED, 
			static::UPDATED, $this->updated( ) );
		return $result;
	}
	
}

#-----------------------------------
function bpdbjobs_summary( ) { return new bpdbjobs_summary( ); }
function bpplclients( ) { return new bpplclients( ); }
function bpflist_backupid( $backupid ) { return new bpflist_backupid( $backupid ); }
#function bpimagelist_hoursago( $hours = 24 ) { return new bpimagelist_hoursago( $hours ); }
function bpimmedia( $days = 7 ) { return new bpimmedia( date( 'm/d/Y H:i:s', time( ) - ( 60 * 60 * ( 24 * $days + 1 ) ) ) ); }
function bpimmedia_client( $client ) { return new bpimmedia_client( $client ); }
function bpdbjobs_report( $days = 7 ) { return new bpdbjobs_report( date( 'm/d/Y H:i:s', time( ) - ( 60 * 60 * ( 24 * $days + 1 ) ) ) ); }
function bppllist_policies( ) { return new bppllist_policies( ); }
function bppllist_clients( ) { return new bppllist_clients( ); }
function bppllist_schedules( ) { return new bppllist_schedules( ); }
function vault_xml( $home ) { return new vault_xml( $home ); }
function bpretlevel( ) { return new bpretlevel( ); }
function nbstl( ) { return new nbstl( ); }
function nbdevquery_listdv_puredisk( ) { return new nbdevquery_listdv_puredisk( ); }

function nbu( ) { global $nbu; return $nbu; }

$nbu = new nbu( );
