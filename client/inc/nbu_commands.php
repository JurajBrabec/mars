<?php

/*
 * MARS 4.0 PHP CODE
 * build 4.0.0.0 @ 2016-09-11 00:00
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

### BPCLIENTS

class bpclients extends nbu {
	const WIN_BIN	= 'admincmd\\bpclients';
	const ARGUMENTS	= '-All -l';
	const NAME		= 'name';
	const HOST		= 'host';
	const DUMMY		= 'dummy';
	const INFO		= 'info';
	const UPDATED				= 'updated';
	const OBSOLETED				= 'obsoleted';

	private $updated			= '';
	private $clients			= array( );
	
	public function updated( $value = NULL ) { return _var( $this->updated, func_get_args( ) ); }
	public function clients( $field = NULL, $value = NULL) { return _arr( $this->clients, func_get_args( ) ); }
	
	public static function pattern( ) {
		$pattern = array(
			sprintf( 'Client Name: %s', text::P( static::NAME ) ),
			sprintf( 'CURRENT HOST\s+%s', text::P( static::HOST ) ),
			sprintf( '%s', text::P( static::DUMMY ) ),
			sprintf( 'HOST INFO\s+%s', text::P( static::INFO, text::ALL ) ) 
		);
		return sprintf( static::PATTERN, implode( text::SPACES, $pattern ) );
	}

	protected function setup( ) {
		parent::setup( );
		$this->row_delimiter( text::DOUBLE_NEW_LINE );
		$this->add_fields( static::UPDATED, $this->updated( date( 'Y-m-d H:i:s' ) ) );
		$this->add_fields( static::OBSOLETED, NULL );
	}

	protected function parse_split( $split ) {
		$result = FALSE;
		echo 'Split:' . $split . PHP_EOL;
		echo 'Pattern:' . $this->field_pattern( ) . PHP_EOL;
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

	protected function parse_rows1( ) {
		parent::parse_rows( );
		foreach ( $this->rows( ) as $row ) $this->clients( $row[ static::NAME ], $row );
	}
	
	public function sql( $table = NULL ) {
		$result = parent::sql( $table );
		$result[ ] = sprintf( "update %s set %s=%s where %s is null and %s<'%s';", $table, 
			static::OBSOLETED, static::UPDATED, static::OBSOLETED, static::UPDATED, $this->updated( ) );
		return $result;
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

	public function sql( $table = NULL ) {
		$result = parent::sql( $table );
		$result[ ] = sprintf( "update %s set %s=%s where %s is null and %s<'%s';", $table, 
			static::OBSOLETED, static::UPDATED, static::OBSOLETED, static::UPDATED, $this->updated( ) );
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
	const INCLUDES			= 'include';

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
		$this->parsing_errors( array_unique( array_merge(
				$this->_clients( )->parsing_errors( ),
				$this->_schedules( )->parsing_errors( ) ) ) );
		$this->clients( $this->_clients( )->clients( ) );
		$this->schedules( $this->_schedules( )->schedules( ) );
	}
	
	public function sql( $table = NULL ) {
		$result = array_merge( parent::sql( $table ), 
			$this->_clients( )->sql( get_class( $this->_clients( ) ) ), 
			$this->_schedules( )->sql( get_class( $this->_schedules( ) ) )
		);
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
	private $home				= NULL;
	
	public function home( $value = NULL ) { return _var( $this->home, func_get_args( ) ); }
	
	public function __construct( $home ) {
		if ( !file_exists( $home ) ) throw new exception( sprintf( static::FILE_NOT_EXISTS_EXCEPTION, $home ) );
		$this->home( $home );
		$this->setup( );
		$this->parse( );
	}
	
	public function setup( ) {
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
				foreach( $this->items( $robot, 'VAULT', 0 ) as $vault ) {
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
	
	public function SQL( $table = NULL ) {
		$masterserver = nbu( )->masterserver( );
		$vault_sql = 'replace into vault_xml (`masterserver`,`robot_id`,`robot_lastmod`,`robot_name`,`robotnumber`,`robottype`,`roboticcontrolhost`,`usevaultprefene`,`robot_ene`,
	`customerid`,`vault_id`,`vault_lastmod`,`vault_name`,`offsitevolumegroup`,`robotvolumegroup`,`vaultcontainers`,`vaultseed`,`vendor`,`profile_id`,`profile_lastmod`,`profile_name`,`endday`,`endhour`,`startday`,`starthour`,
	`ipf_enabled`,`clientfilter`,`backuptypefilter`,`mediaserverfilter`,`classfilter`,`schedulefilter`,`retentionlevelfilter`,`ilf_enabled`,`sourcevolgroupfilter`,`volumepoolfilter`,`basicdiskfilter`,`diskgroupfilter`,
	`duplication_skip`,`duppriority`,`multiplex`,`sharedrobots`,`sortorder`,`altreadhost`,`backupserver`,`readdrives`,`writedrives`,`fail`,`primary`,`retention`,`sharegroup`,`stgunit`,`volpool`,`catalogbackup_skip`,
	`eject_skip`,`ejectmode`,`eject_ene`,`suspend`,`suspendmode`,`userbtorvaultprefene`,`imfile`,`mode`,`useglobalrptsdist`) values ';
		$vault_item_sql = 'replace into vault_item_xml (`masterserver`,`profile`,`type`,`value`) values ';
		foreach( $this->items( $this->rows( ), 'VAULT_MGR', 1 ) as $vault_mgr )
			foreach( $this->items( $vault_mgr, 'ROBOT', 0 ) as $robot )
				foreach( $this->items( $robot, 'VAULT', 0 ) as $vault ) {
					foreach( $this->items( $vault, 'PROFILE', 0 ) as $profile ) {
						foreach( $this->items( $profile, 'SELECTION', 1 ) as $selection ) {
							foreach( $this->items( $selection, 'IMAGE_PROPERTIES_FILTERS', 1 ) as $ipf ) {
								foreach ( $this->items( $ipf, 'CLIENT_FILTER', 1 ) as $clientfilter )
									foreach ( $this->items( $clientfilter, 'CLIENT' ) as $client )
										$vault_item_sql .= sprintf( '("%s","%s","%s","%s")', $masterserver, $profile[ 'Name' ], 'CLIENT', $client[ 0 ] ) . ',' . PHP_EOL;
								foreach ( $this->items( $ipf, 'BACKUP_TYPE_FILTER', 1 ) as $btf );
								foreach ( $this->items( $ipf, 'MEDIA_SERVER_FILTER', 1 ) as $mediaserverfilter );
								foreach ( $this->items( $ipf, 'CLASS_FILTER', 1 ) as $classfilter )
									foreach ( $this->items( $classfilter, 'CLASS' ) as $class )
										$vault_item_sql .= sprintf( '("%s","%s","%s","%s")', $masterserver, $profile[ 'Name' ], 'CLASS', $class[ 0 ] ) . ',' . PHP_EOL;
								foreach ( $this->items( $ipf, 'SCHEDULE_FILTER', 1 ) as $schedulefilter )
									foreach ( $this->items( $schedulefilter, 'SCHEDULE' ) as $schedule )
										$vault_item_sql .= sprintf( '("%s","%s","%s","%s")', $masterserver, $profile[ 'Name' ], 'SCHEDULE', $schedule[ 0 ] ) . ',' . PHP_EOL;
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
								$vault_sql .= sprintf( '(%s),', implode( ',', $row ) ) . PHP_EOL;
				}
			}
			$vault_sql = substr_replace( $vault_sql, ';', strrpos( $vault_sql, ',' ), 1 );
			$vault_item_sql = substr_replace( $vault_item_sql, ';', strrpos( $vault_item_sql, ',' ), 1 );
			return array( $vault_sql, $vault_item_sql );
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

#-----------------------------------
function bpdbjobs_summary( ) { return new bpdbjobs_summary( ); }
function bpclients( ) { return new bpclients( ); }
function bpdbjobs_report( $days = 7 ) { return new bpdbjobs_report( date( 'm/d/Y H:i:s', time( ) - ( 60 * 60 * ( 24 * $days + 1 ) ) ) ); }
function bppllist_policies( ) { return new bppllist_policies( ); }
function bppllist_clients( ) { return new bppllist_clients( ); }
function bppllist_schedules( ) { return new bppllist_schedules( ); }
function vault_xml( $home ) { return new vault_xml( $home ); }
function bpretlevel( ) { return new bpretlevel( ); }

function nbu( ) { global $nbu; return $nbu; }

$nbu = new nbu( );
