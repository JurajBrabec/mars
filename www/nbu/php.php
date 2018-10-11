<?php

define( 'StartTime', microtime( true ) );

function fetch_rows( $db, $sql ) {
	$rows = array( );
	if ( $query = mysqli_query( $db, $sql ) ) {
		while( $row = mysqli_fetch_assoc( $query ) ) $rows[ ] = $row;
	} else {
		$rows[ 'error' ] = sprintf( '%s in %s', mysqli_error( $db ), $sql );
	}
	return $rows;
}

function buffer_fetch_rows( $filename, $db, $sql ) {
	$rows = array( );
	if ( $query = mysqli_query( $db, $sql, MYSQLI_USE_RESULT ) ) {
		while( $row = mysqli_fetch_assoc( $query ) ) $rows[ ] = $row;
		mysqli_free_result( $query );
	} else {
		$rows[ 'error' ] = sprintf( '%s in %s', mysqli_error( $db ), $sql );
	}
	return $rows;
}

function update( ) {
	$files = sprintf( '%s/upload/{,.}*.zip', dirname( __FILE__ ) );
	foreach( glob( $files, GLOB_BRACE ) as $file ) {
		$path = pathinfo( realpath( $file ), PATHINFO_DIRNAME );
		$name = pathinfo( realpath( $file ), PATHINFO_FILENAME );
		echo sprintf( 'Found update package "%s.zip".', $name) . PHP_EOL;
		$zip = new ZipArchive;
		if ( $zip->open( $file ) === TRUE ) {
			echo sprintf( 'Extracting update package "%s.zip" to "%s".', $name, $path ) . PHP_EOL;
			$zip->extractTo( $path );
			$zip->close( );
			if( file_exists( sprintf( '%s/%s/.cmd', $path, $name ) ) ) {
				echo sprintf( 'Executing "%s/.cmd" file.', $name );
				$result = exec( sprintf( '%s/%s/.cmd 2>&1', $path, $name ), $output, $errorlevel );
				echo sprintf( ' E:%s', $errorlevel ) . PHP_EOL;
				echo '<-OUTPUT->: ' . PHP_EOL;
				echo implode( PHP_EOL, $output );
				echo PHP_EOL;
				echo '<-END->' . PHP_EOL;
			} else {
				echo sprintf( 'Error: No "%s/.cmd' . '" file found.', $name ) . PHP_EOL;
			}
			echo sprintf( 'Removing update folder "%s".', $name ) . PHP_EOL;
			exec( sprintf( 'rd /s /q "%s/%s"', $path, $name ) );
			echo sprintf( 'Installation of package "%s" was successful.', $name ) . PHP_EOL;
		} else {
			echo sprintf( 'Error: Unable to open package "%s.zip".', $name ) . PHP_EOL;
		}
		echo sprintf( 'Removing update package "%s.zip".', $name ) . PHP_EOL;
		unlink( $file );
	}
}

function scheduler( $starttime ) {
	global $config;
	update( );
	if ( $db = mysqli_connect( $config[ 'ini' ][ 'DB_HOST' ], $config[ 'ini' ][ 'DB_USER' ], $config[ 'ini' ][ 'DB_PWD' ], $config[ 'ini' ][ 'DB_NAME' ] ) ) {
		$site_name = empty( $config[ 'ini' ][ 'SITE_NAME' ] ) ? 'Default site' : $config[ 'ini' ][ 'SITE_NAME' ];
		$bw_start = empty( $config[ 'ini' ][ 'BW_START_TIME' ] ) ? 'midnight' : $config[ 'ini' ][ 'BW_START_TIME' ];
		$sql = sprintf( "replace into config_settings (`name`,`value`) values ('region','%s'),('bw_start','%s');", $site_name, $bw_start );
		if ( !mysqli_query( $db, $sql ) ) echo mysqli_error( $db ) . PHP_EOL;
		$sql = sprintf( "select * from v_schedules where '%s' regexp `time`;", $starttime );
		$schedules = fetch_rows( $db, $sql );
		$i = 1;
		foreach( $schedules as $schedule ) {
			try {
				$scheduledreports = array( );
				foreach( json_decode( $schedule[ 'sources' ], true ) as $scheduledreport ) {
					foreach( $config[ 'sources' ]  as $source ) {
						if( $source[ 'report' ] == $scheduledreport[ 'name' ] && $source[ 'name' ] == $scheduledreport[ 'source' ] ) {
							$fields = array( );
							foreach( $config[ 'fields' ] as $field ) {
								if ( $field[ 'source' ] == $source[ 'name' ] and ( empty( $source[ 'fields' ] ) or preg_match( sprintf( '/(^|,)%s(,|$)/g', $field[ 'name' ] ), $source[ 'fields' ] ) ) ) 
//								if ( $field[ 'source' ] == $source[ 'name' ] )
									$fields[ ] = $field;  
							}
							$formats = array( );
							foreach( $config[ 'formats' ] as $format ) {
								if ( preg_match( sprintf( '/%s/i', $format[ 'source' ] ), $source[ 'name' ] ) ) $formats[ ] = $format;
							}
							$source[ 'fields' ] = $fields;
							$source[ 'formats' ] = $formats;
							$source[ 'classes' ] = $config[ 'classes' ];
							$source[ 'filters' ] = $scheduledreport[ 'filters' ];
							$source[ 'sorts' ] = $scheduledreport[ 'sorts' ];
							$source[ 'pagination' ] = 0;
							$source[ 'page' ] = 1;
							$source['highlight' ] = 0;
							$scheduledreports[ ] = $source;
						}
					}
				}
				echo sprintf( "%s\tSending report %s/%s '%s'... ", date( 'Y-m-d H:i:s' ), $i, count( $schedules ), $schedule[ 'title' ] );
				$result = send_report( $schedule[ 'name' ], $schedule[ 'title' ], json_encode( $scheduledreports ), $schedule[ 'tower' ], $schedule[ 'customer' ], $schedule[ 'timeperiod' ], $schedule[ 'mode' ], $schedule[ 'to' ], $schedule[ 'cc' ] );
				echo $result;
			} catch ( exception $e ) {
				echo sprintf( 'Failed: %s', $e->getmessage( ) );
			}
			echo PHP_EOL;
			$i++;
		}
	} else {
		echo 'Error: ' . mysqli_connect_error( $db ) . PHP_EOL;
	}
}

function get_datetime( $timeperiod, $bw_start = 'midnight' ) {
	preg_match( '/(?P<key>[HDWMNY])(?P<sign>[+-]*)(?P<value>\d*)/', $timeperiod, $result );
	$result[ 'sign' ] == '' && $result[ 'sign' ] = '+';
	$result[ 'value' ] == '' && $result[ 'value' ] = '0';
	switch ( $result[ 'key' ] ) {
		case 'H':
			$key = 'hour';
			$start = sprintf( 'Today %s hours', date( 'H' ) );
			break;
		case 'D':
			$key = 'day';
			$start = sprintf( 'Today %s', $bw_start );
			break;
		case 'W':
			$key = 'week';
#	PHP BUG FOR SUNDAYS	RETURNS NEXT MONDAY	$start = 'Monday this week midnight';
			$start = sprintf( date( 'w' ) == 1 ? 'Today %s' : 'Last Monday %s', $bw_start );
			break;
		case 'N':
			$key = 'month';
			$start = sprintf( '+14 day %s', date( 'Y-m-d H:i:s', strtotime( sprintf( 'first day of this month %s', $bw_start ) ) ) );
			break;
		case 'Y':
			$key = 'year';
			$start = sprintf( 'First day of january %s', $bw_start );
			break;
		case 'M':
		default:
			$key = 'month';
			$start = sprintf ('First day of this month %s', $bw_start );
			break;
	}
	return strtotime( sprintf( '%s%s %s', $result[ 'sign' ], $result[ 'value' ], $key ), strtotime( $start ) );
}

function get_config( ) {
	global $ini;
	
	if ( isset( $_SESSION[ 'config' ] ) ) unset( $_SESSION[ 'config' ] );
	if( isset( $_SESSION[ 'password' ] ) ) unset( $_SESSION[ 'username' ] );
	if ( isset( $_SESSION[ 'password' ] ) ) unset( $_SESSION[ 'password' ] );
	if ( isset( $_SESSION[ 'config' ] ) ) {
		$config = $_SESSION[ 'config' ];
	} else {
		$config = array( );
		$config[ 'root' ] = substr( __DIR__, 0, strpos( __DIR__, 'www' ) );
		if ( $db = mysqli_connect( $ini[ 'DB_HOST' ], $ini[ 'DB_USER' ], $ini[ 'DB_PWD' ], $ini[ 'DB_NAME' ] ) ) {
			define( 'MariaDBVersion', implode( sscanf( mysqli_get_server_info( $db ), '5.5.5-%d.%d.%d-MariaDB' ), '.' ) );
			$sql = 'select * from config_towers where obsoleted is null order by name;';
			$config[ 'towers' ] = array_merge( array( array( 'name' => 'All towers' ) ), fetch_rows( $db, $sql ) );
			$sql = 'select * from config_customers where obsoleted is null order by name;';
			$config[ 'customers' ] = array_merge( array( array( 'name' => 'All customers' ) ), fetch_rows( $db, $sql ) );
			$sql = 'select * from config_timeperiods where obsoleted is null order by ord;';
			$config[ 'timeperiods' ] = fetch_rows( $db, $sql );
			$sql = 'select * from config_reports where obsoleted is null order by name;';
			$config[ 'userreports' ] = fetch_rows( $db, $sql );
			$sql = 'select * from config_schedules where obsoleted is null order by name;';
			$config[ 'scheduledreports' ] = fetch_rows( $db, $sql );
			$sql = 'select * from core_reports where obsoleted is null order by ord;';
			$config[ 'reports' ] = fetch_rows( $db, $sql );
#			$sql = 'select * from core_sources where obsoleted is null order by report,ord;';
			$sql = 'select * from core_sources where obsoleted is null order by ord;';
			$config[ 'sources' ] = fetch_rows( $db, $sql );
#			$sql = 'select * from core_fields where obsoleted is null order by source,ord;';
			$sql = 'select * from core_fields where obsoleted is null order by ord;';
			$config[ 'fields' ] = fetch_rows( $db, $sql );
#			$sql = 'select * from core_links where obsoleted is null order by source,target,ord;';
			$sql = 'select * from core_links where obsoleted is null order by ord;';
			$config[ 'links' ] = fetch_rows( $db, $sql );
#			$sql = 'select * from core_filters where obsoleted is null order by report,ord,source;';
			$sql = 'select * from core_filters where obsoleted is null order by ord;';
			$config[ 'filters' ] = fetch_rows( $db, $sql );
#			$sql = 'select * from core_sorts where obsoleted is null order by report,ord,source;';
			$sql = 'select * from core_sorts where obsoleted is null order by ord;';
			$config[ 'sorts' ] = fetch_rows( $db, $sql );
#			$sql = 'select * from core_formats where obsoleted is null order by report,ord,source;';
			$sql = 'select * from core_formats where obsoleted is null order by ord;';
			$config[ 'formats' ] = fetch_rows( $db, $sql );
			$classes = array( );
			foreach( $config[ 'formats' ] as $format ) {
				if ( !strpos( $format[ 'style' ], ':' ) ) continue;
				in_array( $format[ 'style' ], $classes ) === false && $classes[ ] = $format[ 'style' ];
			}
			$config[ 'classes' ] = $classes;
			$sql = "select value from config_settings where name='bw_start';"; 
			$config[ 'bw_start' ] = fetch_rows( $db, $sql )[ 0 ][ 'value' ];
			mysqli_close( $db );
		} else {
			$config[ 'error' ] = 'Connect error (' . mysqli_connect_errno() . '): ' . mysqli_connect_error();
		}
	}
	$config[ 'ini' ] = $ini;
	$config[ 'build' ] = trim( file_get_contents( sprintf( '%s/build', $config[ 'root' ] ) ) );
	$config[ 'copyright' ] = get_copyright( );
	$_SESSION[ 'config' ] = $config;
	return $_SESSION[ 'config' ];
}

function get_admin_config( ) {
	global $ini;
	
	$config = array( );
	$config[ 'root' ] = substr( __DIR__, 0, strpos( __DIR__, 'www' ) );
	$config[ 'username' ] = empty( $_SESSION[ 'username' ] ) ? '' : $_SESSION[ 'username' ];
	$config[ 'password' ] = empty( $_SESSION[ 'password' ] ) ? '' : $_SESSION[ 'password' ];
	if ( $db = mysqli_connect( $ini[ 'DB_HOST' ], $ini[ 'DB_USER' ], $ini[ 'DB_PWD' ], $ini[ 'DB_NAME' ] ) ) {
		define( 'MariaDBVersion', implode( sscanf( mysqli_get_server_info( $db ), '5.5.5-%d.%d.%d-MariaDB' ), '.' ) );
		$sql = 'select name,policyname,created,updated,obsoleted from config_towers order by name;';
		$config[ 'towers' ] = fetch_rows( $db, $sql );
		$sql = 'select name,policyname,created,updated,obsoleted from config_customers order by name;';
		$config[ 'customers' ] = fetch_rows( $db, $sql );
		$sql = 'select ord,name,value,created,updated,obsoleted from config_timeperiods order by ord;';
		$config[ 'timeperiods' ] = fetch_rows( $db, $sql );
		$sql = 'select title,tower,customer,timeperiod,sources,created,updated,obsoleted from config_reports order by name;';
		$config[ 'userreports' ] = fetch_rows( $db, $sql );
		$sql = 'select `date`,`time`,title,tower,customer,timeperiod,mode,`to`,cc,sources,created,updated,obsoleted from config_schedules order by name;';
		$config[ 'scheduledreports' ] = fetch_rows( $db, $sql );
		$sql = 'select * from core_admin_sources where obsoleted is null order by ord;';
		$config[ 'sources' ] = fetch_rows( $db, $sql );
#		$sql = 'select * from core_admin_fields where obsoleted is null order by source,ord;';
		$sql = 'select * from core_admin_fields where obsoleted is null order by ord;';
		$config[ 'fields' ] = fetch_rows( $db, $sql );
		$sql = "select `status` from information_schema.events where event_name='nbu_event';";
		$config[ 'event' ] = fetch_rows( $db, $sql );
		$sql = "select 'routine',ifnull((select value from config_settings where name='routine'),'0') as value,ifnull((select updated from config_settings where name='routine'),'never') as updated from dual";
		$config[ 'routine_duration' ] = fetch_rows( $db, $sql )[ 0 ];
		$sql = "select 'maintenance',ifnull((select value from config_settings where name='maintenance'),'0') as value,ifnull((select updated from config_settings where name='maintenance'),'never') as updated from dual";
		$config[ 'maintenance_duration' ] = fetch_rows( $db, $sql )[ 0 ];
		$sql = "select value from config_settings where name='bw_start';"; 
		$config[ 'bw_start' ] = fetch_rows( $db, $sql )[ 0 ][ 'value' ];
		mysqli_close( $db );
	} else {
		$config[ 'error' ] = mysqli_connect_error( $db );
	}
	$config[ 'ini' ] = $ini;
	$config[ 'build' ] = trim( file_get_contents( sprintf( '%s/build', $config[ 'root' ] ) ) );
	$config[ 'copyright' ] = get_copyright( );
	return $config;
}

function matches( $row, $format ) {
	$result = false;
	$value = is_array( $row ) ? isset( $row[ $format[ 'field' ] ] ) ? $row[ $format[ 'field' ] ] : '' : $row;
	switch( strtolower( $format[ 'operator' ] ) ) {
		case 'matches':
		case 'regexp': 	$result = preg_match( sprintf( '/%s/i', $format[ 'value' ] ), $value ); break;
		case 'not match':
		case 'not regexp': 	$result = !preg_match( sprintf( '/%s/i', $format[ 'value' ] ), $value ); break;
		case 'is':
		case '=': 	$result = $value == $format[ 'value' ]; break;
		case 'is not':
		case '!=': 	$result = $value != $format[ 'value' ]; break;
		case 'is more or equal than':
		case '>=': 	$result = $value >= $format[ 'value' ]; break;
		case 'is less or equal than':
		case '<=': 	$result = $value <= $format[ 'value' ]; break;
		case 'is more than':
		case '>': 	$result = $value > $format[ 'value' ]; break;
		case 'is less than':
		case '<': 	$result = $value < $format[ 'value' ]; break;
	}
	return $result;
}
function get_classname( $style, $classes ) {
	$id = array_search( $style, $classes );
	return $id === false ? $style : sprintf( 'cl-%s', $id );
}
function get_description( $source ) {
	global $operators;
	$description = $source[ 'description' ];
	count( $source[ 'filters' ] ) > 0 && $description .= ', where ';
	$join = '';
	$i = 1;
	foreach( $source[ 'filters' ] as $filter ) {
		$description .= $join;
		foreach( $source[ 'fields' ] as $item ) $item[ 'name' ] == $filter[ 'field' ] && $description .= sprintf( '%s', $item[ 'title' ] );
		foreach( $operators as $item ) $item[ 'name' ] == $filter[ 'operator' ] && $description .= sprintf( ' %s', $item[ 'title' ] );
		$description .= sprintf( ' <strong>\'%s\'</strong>', get_value( $source, $filter[ 'field' ], $filter[ 'value' ] ) );
		$join == '' && $join = ', ';
		$i == count( $source[ 'filters' ] ) - 1 && $join = ' and ';
		$i++;
	}
	count( $source[ 'sorts' ] ) > 0 && $description .= ', sorted by ';
	$join = '';
	$i = 1;
	foreach( $source[ 'sorts' ] as $sort ) {
		$description .= $join;
		$field = '';
		foreach( $source[ 'fields' ] as $item ) $item[ 'name' ] == $sort[ 'field' ] && $field = $item[ 'title' ];
		$description .= sprintf( '%s', $field );
#		foreach( $sorts as $item ) $item[ 'name' ] == $sort[ 'sort' ] && $description .= sprintf( ' %s', $item[ 'title' ] );
		foreach( $source[ 'fields' ] as $item ) $item[ 'name' ] == $sort[ 'sort' ] && $description .= sprintf( ' %s', $item[ 'title' ] );
		$join == '' && $join = ', ';
		$i == count( $source[ 'sorts' ] ) - 1 && $join = ' and ';
		$i++;
	}
	return $description;
}
function get_legend( $source ) {
	$legend = '<table><tr>';
	foreach( $source[ 'formats' ] as $format ) {
		$legend .= sprintf( '<td class="%s">%s</td>', get_classname( $format[ 'style' ], $source[ 'classes' ] ), $format[ 'description' ] );
	}
	$legend .= '</tr></table>';
	return $legend;
}


function get_sql( $source ) {
	$alias = 'a';
	$fields = array( );
	$types = array( );
	$filters = array( );
	$sorts = array( );
	foreach( $source[ 'fields' ] as $field ) {
		$fields[ ] = sprintf( '%s.`%s`', $alias, $field[ 'name' ] );
		$types[ $field[ 'name' ] ] = $field[ 'type' ];
	}
	foreach( $source[ 'filters' ] as $filter ) {
		$field = $filter[ 'field' ];
		$operator = $filter[ 'operator' ];
		$value = sprintf( "'%s'", $filter[ 'value' ] );
		if ( $types[ $field ] == 'DATE' and 
				preg_match( '/^(?P<sign>[+|-]?)(?P<num>\d+) (?P<int>(?:year|month|week|day|hour|minute))s?$/i', 
					$filter[ 'value' ], $match ) ) {
			$match[ 'sign' ] == '' && $match[ 'sign' ] = '+';
			$value = sprintf( '(now() %s interval %s %s)', $match[ 'sign' ], $match[ 'num' ], $match[ 'int' ] );
		}
		if ( $types[ $field ] == 'NUMBER' ) {
			$value = str_replace( ' ','', $filter[ 'value' ] );
		}
		if ( $types[ $field ] == 'STRING' and $filter[ 'value' ] == '' and in_array( $operator, array( '=', '!=' ) ) ) {
			$operator = $operator == '=' ? 'is' : 'is not';
			$value = 'null';
		}
		$filters[ ] = sprintf( "%s.`%s` %s %s", $alias, $field, $operator, $value );
	}
	foreach( $source[ 'sorts' ] as $sort ) {
		$sorts[ ] = sprintf( '%s.`%s` %s', $alias, $sort[ 'field' ], $sort[ 'sort' ] );
	}
	$sql = sprintf( 'SELECT %s FROM `%s` %s', implode(', ', $fields ), $source[ 'name' ], $alias );
	count( $filters ) > 0 && $sql .= sprintf( ' WHERE %s', implode( ' AND ', $filters ) );
	count( $sorts ) > 0 && $sql .= sprintf( ' ORDER BY %s', implode( ', ', $sorts ) );
	$source[ 'pagination' ] == 1 && $sql .= sprintf( ' LIMIT %s,%s', ( $source[ 'page' ] - 1 ) * $source[ 'limit' ], $source[ 'limit' ] );
	$sql .= ';';
	return $sql;
}
function get_classes( $source, $key, $value, $i ) {
	$class = array( );
	foreach( $source[ 'formats' ] as $format ) {
		if( $key == '' and $format[ 'fields' ] != '' ) continue;
		if( $key != '' and !strstr( $format[ 'fields' ], $key ) ) continue;
		if ( matches( $value, $format ) ) $class[ $format[ 'field' ] ] =  get_classname( $format[ 'style' ], $source[ 'classes' ] );
//		if ( matches( $value, $format ) ) $class[ 'class' ] =  get_classname( $format[ 'style' ], $source[ 'classes' ] );
	}
	if ( $key == '' ) {
		if ( $source[ 'highlight' ] == $source[ 'pagination' ] * ( $source[ 'page' ] - 1 ) * $source[ 'limit' ] + $i + 1 ) {
			$class[ ] = 'highlight';
		}
	} else {
		foreach( $source[ 'fields' ] as $field ) {
			if ( $field[ 'name' ] != $key ) continue;
			switch ( $field[ 'type' ] ) {
				case 'NUMBER':
				case 'FLOAT':
					$class[ ] = 'num';
					break;
				case 'DATE':
				case 'TIME':
					$class[ ] = 'dts';
					break;
			}
		}
	}	
	return implode( ' ', $class );
}
function get_value( $source, $key, $value ) {
	$cell_value = $value;
	foreach( $source[ 'fields' ] as $field ) {
		if ( $field[ 'name' ] != $key ) continue;
		switch ( $field[ 'type' ] ) {
			case 'NUMBER':
				$cell_value != '' && $cell_value = @number_format( $cell_value, 0, ',', ' ' );
				break;
			case 'FLOAT':
				$cell_value != '' && $cell_value = @number_format( $cell_value, 1, ',', ' ' );
				break;
			case 'DATE':
			case 'TIME':
				break;
		}
	}
	return $cell_value;
}

function get_field_name( $source, $name ) {
	$result = $name;
	foreach( $source[ 'fields' ] as $field ) $field[ 'name' ] == $name && $result = $field[ 'title' ];
	return $result;
}
function get_head( $source, $c ) {
	$result = '<thead>';
	$pivots = array_keys( $c );
	$i = count( $source[ 'fields' ] ) - count( $pivots );
	$pivotx = count( $pivots ) > 0 ? array_shift( $pivots ) : '';
	$colspans = array( );
	foreach( array_reverse( $pivots ) as $pivot ) {
		$colspans[ $pivot ] = $i;
		$i = $i * count( $c[ $pivot ] );
	}
	$i = 1;
	foreach( $pivots as $pivot ) {
		$result .= sprintf( '<tr id="%s">', $pivot );
		$result .= sprintf( '<th>%s</th>', get_field_name( $source, $pivot ) );
		for( $j = 1; $j <= $i; $j++ ) foreach(  $c[ $pivot ] as $title ) {
			$result .= sprintf( '<th colspan="%s">%s</th>', $colspans[ $pivot ], $title );
		}
		$i = $i * count( $c[ $pivot ] );
		$result .= '</tr>';
	}
	$result .= '<tr>';
	count( $pivots ) > 0 && $result .= sprintf( '<th>%s</th>', get_field_name( $source, $pivotx ) );
	for( $j = 1; $j <= $i; $j++ ) foreach(  $source[ 'fields' ] as $field ) {
		$field[ 'name' ] != $pivotx && array_search( $field[ 'name' ], $pivots ) === false && $result .= sprintf( '<th>%s</th>', $field[ 'title' ] );
	}
	$result .= '</tr>';
	$result .= '</thead>';
	return $result;
}

function get_body( $source, $c, $r, $i = 0 ) {
	$result = '';
	$pivots = array_keys( $c );
	$i == 0 && $result .= '<tbody>';
	if ( count( $pivots ) == 0 ) {
		foreach( $r as $row ) {
			$classes = get_classes( $source, '', $row, $i );
			$result .= sprintf( '<tr%s>', $classes == '' ? '' : sprintf( ' class="%s"', $classes ) );
			foreach( $row as $field => $value ) {
				$classes = get_classes( $source, $field, $value, $i );
				$result .= sprintf( '<td%s>', $classes == '' ? '' : sprintf( ' class="%s"', $classes ) );
				$result .= get_value( $source, $field, $value );
				$result .= '</td>';
			}
			$result .= '</tr>';
		}
	} else foreach( $c[ $pivots[ $i ] ] as $pivot ) {
		$row = isset( $r[ $pivot ] ) ? $r[ $pivot ] : array_fill( 0, count( $source[ 'fields' ] ) - $i - 1, '' );
		if ( $i == 0 ) {
			$result .= '<tr>';
			$result .= sprintf( '<th>%s</th>', $pivot );
		}
		if ( isset( $pivots[ $i + 1 ] ) ) {
			$result .= get_body( $source, $c, isset( $r[ $pivot ] ) ? $r[ $pivot ] : array( ), $i + 1 );
		} else {
			foreach( $row as $field => $value ) {
				$classes = get_classes( $source, '', $row, $i );
				$classes != '' && $classes .= ' ';
				$classes .= get_classes( $source, $field, $value, $i );
				$result .= sprintf( '<td%s>', $classes == '' ? '' : sprintf( ' class="%s"', $classes ) );
				$result .= get_value( $source, $field, $value );
				$result .= '</td>';
			}
		}
		if ( $i == 0 ) $result .= '</tr>';
	}
	$i == 0 && $result .= '</tbody>';
	return $result;
}

function get_copyright_item( $text, $version = '', $link = '' ) {
	return $link == '' ? sprintf( '<strong>%s %s</strong>', $text, $version ) : sprintf( '<strong><a target="_blank" href="%s" title="%s">%s %s</a></strong>', $link, $text, $text, $version );
}
function get_copyright( $duration = 0 ) {
	global $config;
	if ( PHP_SAPI === 'cli' ) return sprintf( 'MARS %s &copy; 2015-%s Juraj Brabec, DXC.technology', $config[ 'build' ], date( 'Y' ) );
	$result = '<span id="line-1">';
	$result .= get_copyright_item( 'MARS ', $config[ 'build' ] );
	$result .= sprintf( ' &copy; 2015 - %s', date( 'Y' ) );
	$result .= ' Juraj Brabec, ';
	$result .= get_copyright_item( 'DXC Technology Company', '', 'https://dxc.technology' );
	$result .= '. ';
	$result .= sprintf( 'Prepared on %s (%s)', get_copyright_item( date( 'F j, Y, H:i' ) ), date_default_timezone_get( ) );
	$duration > 0 && $result .= sprintf( ' in %s seconds.', round( $duration, 1 ) );
	$result .= '</span><br><span id="line-2">';
	$items = array( );
	$items[ ] = get_copyright_item( 'HTML5' );
	$items[ ] = get_copyright_item( 'CSS3' );
	$items[ ] = get_copyright_item( 'JavaScript' );
	$items[ ] = get_copyright_item( 'JQuery','', 'https://jquery.com' );
	$items[ ] = get_copyright_item( 'JQueryUI','', 'https://jqueryui.com' );
	$items[ ] = get_copyright_item( 'Bootstrap', '', 'https://getbootstrap.com' );
	$items[ ] = get_copyright_item( 'PHP', phpversion( ), 'https://php.net' );
	$items[ ] = get_copyright_item( 'MariaDB', MariaDBVersion, 'https://mariadb.org' );
	$items[ ] = get_copyright_item( 'Apache', sscanf( apache_get_version( ), 'Apache/%s ' )[ 0 ], 'https://httpd.apache.org' );
	$result .= implode( ' | ', $items );
	$result .= '</span>';
	return $result;
}
function set_data( $row, $pivots, $data ) {
	if( count( $pivots ) == 0 ) {
		$result = $data;
	} else {
		$pivot = array_shift( $pivots );
		$result[ $row[ $pivot ] ] = set_data( $row, $pivots, $data );
	}
	return $result;
}

function get_source( $source, $tower, $customer, $timeperiod, $mode ) {
	global $ini,$config;
	
	$result = '';
	$tower = $tower == 'All towers' ? '' : $tower;
	$customer = $customer == 'All customers' ? '' : $customer;
	if ( empty( $timeperiod ) ) {
		$from = '';
		$to = '';
	} else {
		list( $f, $t ) = explode( '::', $timeperiod );
		$from = get_datetime( $f, $config[ 'bw_start' ] );
		$to = get_datetime( $t, $config[ 'bw_start' ] );
	}
	switch( $mode ) {
		case 'HTML':
		case 'no-data':
			$result .= sprintf( '<div id="%s" class="container">', $source[ 'name' ] );
			$result .= sprintf( '<div class="title">%s</div>', $source[ 'title' ] );
			$result .= '<div class="body">';
			$description = get_description( $source );
			$source[ 'tower' ] && !empty( $tower ) && $description .= sprintf( ", for '<strong>%s</strong>' tower", $tower );
			$source[ 'timeperiod' ] && !empty( $timeperiod ) && $description .= sprintf( ', for time period between <strong>%s</strong> and <strong>%s</strong>', date( 'F j, Y, H:i', $from ), date( 'F j, Y, H:i', $to ) );
			$source[ 'customer' ] && !empty( $customer ) && $description .= sprintf( " and for customer '<strong>%s</strong>'", $customer );
			$result .= sprintf( '<div class="description">%s</div>', $description );
			$result .= '<div class="report">';
			$result .= '<table>';
			if ( $mode == 'HTML' ) {
				$data = get_source( $source, $tower, $customer, $timeperiod, 'data' );
				$rows = number_format( substr_count( $data, '<tr' ), 0, ',', ' ' ) - 1;
				$result .= $data;
			} else {
				$rows = 0;
			}
			$result .= '</table>';
			$result .= '</div>';
			$result .= '</div>';
			$result .= '<div class="footer">';
			$result .= '<table><tr><td align="left">';
			$result .= sprintf( '<span class="rows">Rows: <strong>%s</strong></span>', $rows );
			$result .= '</td><td class="legend" width="99%" align="right">';
			if ( count( $source[ 'formats' ] ) > 0 ) $result .= get_legend( $source );
			$result .= '</td></tr></table>';
			$result .= '</div>';
			$result .= '</div>';
			break;
		case 'CSV':
		case 'data':
			$filename = sprintf( '%s/%s_%s-rows.txt', sys_get_temp_dir( ), session_id( ), $source[ 'name' ] );
			if ( file_exists( $filename ) and !empty( $source[ 'reload' ] ) ) {
				$rows = json_decode( file_get_contents( $filename ), true );
			} else {
				if ( $db = mysqli_connect( $ini[ 'DB_HOST' ], $ini[ 'DB_USER' ], $ini[ 'DB_PWD' ], $ini[ 'DB_NAME' ] ) ) {
					$sql = sprintf( "set @tower='%s',@customer='%s',@datetime_from='%s',@datetime_to='%s';", 
						$tower, $customer, $from == '' ? '' : date( 'Y-m-d H:i:s', $from ), $to == '' ? '' : date( 'Y-m-d H:i:s', $to ) );
					mysqli_query( $db, $sql );
					$sql = get_sql( $source );
					$rows = fetch_rows( $db, $sql );
					file_put_contents( $filename, json_encode( $rows ) );
					mysqli_close( $db );
				} else {
					return mysqli_connect_error( $db );
				}
			}
			unlink( $filename );
			if ( $mode == 'CSV' ) {
				foreach( $rows as $row ) {
					$delimiter = $ini[ 'TEXT_QUALIFIER' ] . str_replace( '\t', "\t", $ini[ 'DELIMITER' ] ) . $ini[ 'TEXT_QUALIFIER' ] ;
					$row == $rows[ 0 ] && $result .= $ini[ 'TEXT_QUALIFIER' ] . implode( $delimiter, array_keys( $row ) ) . $ini[ 'TEXT_QUALIFIER' ]  . PHP_EOL;
					$result .= $ini[ 'TEXT_QUALIFIER' ]  . implode( $delimiter, $row ) . $ini[ 'TEXT_QUALIFIER' ] . PHP_EOL;
				}
				return $result;
			}
			if ( isset( $rows[ 'error' ] ) ) {
				return sprintf( '<thead><tr><th>Error</th></tr></thead><tbody></tr><tr class="dred"><td>%s</td></tr></tbody>', $rows[ 'error' ] );
			}
			$c = $r = array( );
			$pivots = array_filter( explode( ',', $source[ 'pivot' ] ) );
			foreach( $rows as $row ) {
				$data = $row;
				foreach( $pivots as $pivot ) {
					( isset( $c[ $pivot ] ) && array_search( $data[ $pivot ], $c[ $pivot ] ) !== false ) || $c[ $pivot ][ ] = $data[ $pivot ];
					unset( $data[ $pivot ] );
				}
				$r = array_merge_recursive( $r, count( $pivots ) == 0 ? array( $data ) : set_data( $row, $pivots, $data ) );
			}
			foreach( array_keys( $c ) as $pivot ) {
				if ( $pivot == current( array_keys( $c ) ) ) continue;
				sort( $c[ $pivot ] );
			}
			$result .= get_head( $source, $c );
			$result .= get_body( $source, $c, $r );
//			$result .= '<tfoot></tfoot>';
			break;
	}
	return $result;
}

function sql( $sql, $username = NULL, $password = NULL ) {
	global $ini;
	
	$username = empty( $username ) ? $ini[ 'DB_USER' ] : $username;
	$password = empty( $username ) ? $ini[ 'DB_PWD' ] : $password;
	if ( $db = mysqli_connect( $ini[ 'DB_HOST' ], $username, $password, $ini[ 'DB_NAME' ] ) ) {
		if ( mysqli_query( $db, $sql ) ) {
			$_SESSION[ 'username' ] = $username;
			$_SESSION[ 'password' ] = $password;
			$result = 'OK';
		} else {
			unset( $_SESSION[ 'username' ] );
			unset( $_SESSION[ 'password' ] );
			$result = mysqli_error( $db );
		}
	} else {
		$result = mysqli_connect_error( $db );
	}
	
	return $result;
}

function save_report( $name, $title, $sources, $tower, $customer, $timeperiod ) {
	global $ini;
	
	if ( $db = mysqli_connect( $ini[ 'DB_HOST' ], $ini[ 'DB_USER' ], $ini[ 'DB_PWD' ], $ini[ 'DB_NAME' ] ) ) {
		$sources = mysqli_real_escape_string( $db, $sources );
		$sql = sprintf( "insert into config_reports (name,title,sources,tower,customer,timeperiod) values ('%s','%s','%s',nullif('%s',''),nullif('%s',''),'%s') on duplicate key update title=values(title),tower=values(tower),customer=values(customer),timeperiod=values(timeperiod);",
			$name, $title, $sources, $tower, $customer, $timeperiod );
		if ( mysqli_query( $db, $sql ) ) {
			$result = 'OK';
		} else {
			$result = mysqli_error( $db );
		}
	} else {
		$result = mysqli_connect_error( $db );
	}
	return $result;
}

function schedule_report( $name, $title, $sources, $tower, $customer, $timeperiod, $date, $time, $mode, $to, $cc ) {
	global $ini;
	
	if ( $db = mysqli_connect( $ini[ 'DB_HOST' ], $ini[ 'DB_USER' ], $ini[ 'DB_PWD' ], $ini[ 'DB_NAME' ] ) ) {
		$sources = mysqli_real_escape_string( $db, $sources );
		$tower = mysqli_real_escape_string( $db, $tower );
		$date = mysqli_real_escape_string( $db, $date );
		$time = mysqli_real_escape_string( $db, $time );
		$to = mysqli_real_escape_string( $db, $to );
		$cc = mysqli_real_escape_string( $db, $cc );
		$sql = sprintf( "insert into config_schedules (`date`,`time`,name,title,sources,tower,customer,timeperiod,mode,`to`,cc) values (nullif('%s',''),'%s','%s','%s','%s',nullif('%s',''),nullif('%s',''),'%s','%s','%s',nullif('%s','')) on duplicate key update `date`=values(`date`),`time`=values(`time`),title=values(title),tower=values(tower),customer=values(customer),timeperiod=values(timeperiod),mode=values(mode),`to`=values(`to`),cc=values(cc);",
				$date, $time, $name, $title, $sources, $tower, $customer, $timeperiod, $mode, $to, $cc );
		if ( mysqli_query( $db, $sql ) ) {
			$result = 'OK';
		} else {
			$result = mysqli_error( $db );
		}
	} else {
		$result = mysqli_connect_error( $db );
	}
	return $result;
}

function send_report( $name, $title, $sources, $tower, $customer, $timeperiod, $mode, $to, $cc ) {
	global $config;
	
	$sources = json_decode( $sources, true );
	$title = sprintf( '%s - %s', $config[ 'ini' ][ 'SITE_NAME' ], $title );
	foreach( $config[ 'timeperiods' ] as $period ) {
		$timeperiod = ( $period[ 'name' ] == $timeperiod ) ? $period[ 'value' ] : $timeperiod;
	}
	switch ( $mode ) {
		case 'HTML':
			$result = '';
			$result .= '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">';
			$result .= '<html>';
			$result .= '<head>';
			$result .= sprintf( '<title>%s</title>', $title );
			$result .= '<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">';
			$result .= '<meta http-equiv="X-UA-Compatible" content="IE=edge">';
			$result .= '<style type="text/css">';
			$result .= file_get_contents( sprintf( '%s/css/mars-report.css', __DIR__ ) );
			if ( count( $config[ 'classes' ] ) > 0 ) {
				$i = 0;
				foreach( $config[ 'classes' ] as $class ) {
					$result .= sprintf( '.cl-%s{%s}' , $i, $class );
					$i++;
				}
			}
			$result .= '</style>';
			$result .= '</head>';
			$result .= '<body>';
			$result .= '<table id="header"><tr><td>';
			$result .= '<img alt="Company logo" src="%company-logo%">';
			$result .= sprintf( '</td><td>%s</td></tr></table>', $title );
			$result .= '<br>';
			foreach( $sources as $source ) {
				$source[ 'pagination' ] = 0;
				$result .= get_source( $source, $tower, $customer, $timeperiod, $mode );
			}
			$result .= '<div id="copyright">'. get_copyright( microtime( true ) - StartTime ) .'</div>';
			$result .= '</body>';
			$result .= '</html>';
			break;
		case 'CSV':
			$result = array( );
			foreach( $sources as $source ) {
				$source[ 'pagination' ] = 0;
				$result[ $source[ 'name' ] ] = get_source( $source, $tower, $customer, $timeperiod, $mode );
			}
			break;
		default:
			$result = sprintf( 'Invalid mode "%s"', $mode );
			break;
	}
	echo phpMailer( $name, $title, $to, $cc, $result, $mode );
}

function phpMailer( $name, $title, $to, $cc, $text, $mode ) {
	global $config;
	
	require_once dirname( __FILE__ ) . '/inc/class.smtp.php';
	require_once dirname( __FILE__ ) . '/inc/class.phpmailer.php';
	
	$delims = array( ';', ' ', '|' );
	$name = preg_replace( "([^\w\s\d\-_~,;\[\]\(\).])", '', $name );
	$from = $config[ 'ini' ][ 'SMTP_FROM' ];
	if ( preg_match( '/(.+?)\<(.+?)\>/i', $from, $match ) ) {
		$fname = $match[ 1 ];
		$faddress = $match[ 2 ];
	} else {
		$fname = 'MARS 4.0';
		$faddress = $from;
	}
	$to = str_replace( $delims, ',', $to );
	$cc = !empty( $cc ) ? str_replace( $delims, ',' , $cc ) : '';
	$host = empty( $config[ 'ini' ][ 'SMTP_SERVER' ] ) ? 'localhost' : $config[ 'ini' ][ 'SMTP_SERVER' ];
	$debug = empty( $config[ 'ini' ][ 'SMTP_DEBUG' ] ) ? 0 : $config[ 'ini' ][ 'SMTP_DEBUG' ];
	$port = empty( $config[ 'ini' ][ 'SMTP_PORT' ] ) ? 25 : $config[ 'ini' ][ 'SMTP_PORT' ];
	$limit = empty( $config[ 'ini' ][ 'HTML_SIZE_LIMIT' ] ) ? 2 : $config[ 'ini' ][ 'HTML_SIZE_LIMIT' ];
	$mail = new PHPMailer;
	$mail->isSMTP( );
	$mail->SMTPDebug = $debug;
	$mail->Host = $host;
	$mail->SMTPAuth = false;
	$mail->Port = $port;
	$mail->setFrom( $faddress, $fname );
	foreach( explode( ',', $to ) as $recipient ) empty( $recipient ) || $mail->addAddress( $recipient );
	foreach( explode( ',', $cc ) as $recipient ) empty( $recipient ) || $mail->addCC( $recipient );
	$mail->addReplyTo( $faddress, $fname );
	$mail->Subject = $title;
	$attachment = sprintf( '%s/%s.tmp', sys_get_temp_dir( ), session_id( ) );
	switch ( $mode ) {
		case 'HTML':
			$logo_file = sprintf( '%s/img/company-logo.png', __DIR__ );
			$src = sprintf( 'data:image/png;base64,%s', base64_encode( file_get_contents( $logo_file ) ) );
			if( strlen( $text ) < ( $limit * 1024 * 1024 ) ) {
				file_put_contents( $attachment, str_replace( '%company-logo%', $src, $text ) );
				$mail->isHTML( true );
				$mail->Body = str_replace( '%company-logo%', 'cid:company-logo.png', $text );
				$mail->AltBody = 'HTML mail client required.';
				$mail->addAttachment( $logo_file, 'company-logo.png' );
				$mail->addAttachment( $attachment, sprintf( '%s.html', $name ) );
			} else {
				$zip = new ZipArchive;
				$zip->open( $attachment, ZipArchive::CREATE );
				$zip->addFromString( sprintf( '%s.html', $name ), str_replace( '%company-logo%', $src, $text ) );
				$zip->close( );
				$mail->isHTML( false );
				$mail->Body = sprintf( 'Attached is the ZIP containing the generated reports in HTML format (Exceeded allowed size of inline HTML report %s MB).', $limit );
				$mail->addAttachment( $attachment, sprintf( '%s.zip', $name ) );
			}
			break;
		case 'CSV':
			$zip = new ZipArchive;
			$zip->open( $attachment, ZipArchive::CREATE );
			foreach( $text as $report_name=>$report_contents ) {
				$zip->addFromString( sprintf( '%s.csv', $report_name ), $report_contents );
			}
			$zip->close( );
			$mail->isHTML( false );
			$mail->Body = 'Attached is the ZIP containing the generated reports in CSV format.';
			$mail->addAttachment( $attachment, sprintf( '%s.zip', $name ) );
			break;				
	}
	$result = $mail->send( ) ? 'OK' : sprintf( 'Mail Error: %s', $mail->ErrorInfo );
	unlink( $attachment );
	return $result;
}

$operators = array(
		array( 'name' => 'REGEXP',		'title' => 'matches' ),
		array( 'name' => 'NOT REGEXP',	'title' => 'not match' ),
		array( 'name' => '=',			'title' => 'is' ),
		array( 'name' => '!=',			'title' => 'is not' ),
		array( 'name' => '<',			'title' => 'is less than' ),
		array( 'name' => '>',			'title' => 'is more than' ),
		array( 'name' => '<=',			'title' => 'is less or equal than' ),
		array( 'name' => '>=',			'title' => 'is equal or more than' )
);

$sorts = array(
		array( 'name' => 'ASC', 'title' => 'ascending' ),
		array( 'name' => 'DESC', 'title' => 'descending' )
	);

function error_handler( $errno, $errstr, $errfile, $errline, array $errcontext ) {
	if ( ( 0 === error_reporting( ) ) or ( $errno == 8192 ) ) {return false;}
	throw new ErrorException( $errstr, 0, $errno, $errfile, $errline );
}

date_default_timezone_set( @date_default_timezone_get( ) );
set_error_handler( 'error_handler' );
try {
	$params =  $_REQUEST;
	PHP_SAPI === 'cli' && parse_str( implode( '&', array_slice( $argv, 1 ) ), $params );
	$ini_file = sprintf( '%s/conf/config.ini', substr( __DIR__, 0, strpos( __DIR__, 'www' ) ) );
	$ini = array_change_key_case( parse_ini_file( $ini_file ), CASE_UPPER );
	date_default_timezone_set( $ini[ 'TIME_ZONE' ] );
	if ( PHP_SAPI === 'cli' ) {
		$config = get_config( );
		$starttime = empty( getenv( 'starttime' ) ) ? date( 'H:i' ) : getenv( 'starttime' );
		return scheduler( $starttime ); 
	}
	session_start( );
	switch ( $_SERVER[ 'REQUEST_METHOD' ] ) {
		case 'POST':
			$post = count( $_POST ) == 0 ? json_decode( file_get_contents( 'php://input' ), true ) : $_POST;
			if ( isset( $post[ 'action' ] ) ) {
				if ( $post[ 'action' ] == 'help' ) {
					$xml = simplexml_load_file( dirname( __FILE__ ) . DIRECTORY_SEPARATOR . 'inc' . DIRECTORY_SEPARATOR . 'help-texts.xml' );
					$item = $post[ 'id' ];
					$result = $xml->$item ? $xml->$item->asXML( ) : 'Error retrieving help text for #' . $item;
					echo $result;
				}
				if ( $post[ 'action' ] == 'upload' ) {
					if ( empty( $_FILES[ 'file' ] ) or empty( $_FILES[ 'file' ][ 'name' ] ) ) 
						die( 'Error: No package file selected.' );
					if ( $_FILES[ 'file' ][ 'error' ] != UPLOAD_ERR_OK )
						die( sprintf( 'Error %s encountered during upload.', $_FILES[ 'file' ][ 'error' ] ) );
					$file = basename( $_FILES[ 'file' ][ 'name' ] );
					$ext = pathinfo( $file, PATHINFO_EXTENSION );
					if ( $ext != 'zip' ) 
						die( sprintf( 'Error: File "%s" is not a valid package.', $file ) ); 
					if ( !move_uploaded_file( $_FILES[  'file' ][ 'tmp_name' ], dirname( __FILE__ ) . DIRECTORY_SEPARATOR . 'upload' . DIRECTORY_SEPARATOR . $file ) ) 
						die( sprintf( 'Error moving package "%s".', $file ) );
					echo sprintf( 'Upload of package "%s" was successful.', $file );
				}
				if ( $post[ 'action' ] == 'session-store' ) {
					$sources = json_decode( $post[ 'sources' ], true );
					$_SESSION[ 'sources' ] = $sources;
					$_SESSION[ 'tower' ] = $post[ 'tower' ];
					$_SESSION[ 'customer' ] = $post[ 'customer' ];
					$_SESSION[ 'timeperiod' ] = $post[ 'timeperiod' ];
					echo json_encode( $sources );
				}
				if ( $post[ 'action' ] == 'source-show' ) {
					$config = get_config( );
					$timeperiod = '';
					$source = json_decode( $post[ 'source' ], true );
					$index = -1;
					for( $i = 0; $i < count( $_SESSION[ 'sources' ] ); $i++ ) { 
						if ( $_SESSION[ 'sources' ][ $i ][ 'name' ] == $source[ 'name' ] ) $index = $i;
					}
					if ( $index == -1 ) {
						$_SESSION[ 'sources' ][ ] = $source;
					} else {
						$_SESSION[ 'sources' ][ $index ] = $source;
					}
					foreach( $config[ 'timeperiods' ] as $period ) {
						$timeperiod = ( $period[ 'name' ] == $post[ 'timeperiod' ] ) ? $period[ 'value' ] : $timeperiod;
					}
					echo get_source( $source, $post[ 'tower' ], $post[ 'customer' ], $timeperiod, $post[ 'mode' ] );
				}
				if ( $post[ 'action' ] == 'session-save' ) {
					echo save_report( $post[ 'name' ], $post[ 'title' ], $post[ 'sources' ], $post[ 'tower' ], $post[ 'customer' ], $post[ 'timeperiod' ]);
				}
				if ( $post[ 'action' ] == 'session-send' ) {
					$config = get_config( );
					echo send_report( $post[ 'name' ], $post[ 'title' ], $post[ 'sources' ], $post[ 'tower' ], $post[ 'customer' ], $post[ 'timeperiod' ], $post[ 'mode' ], $post[ 'to' ], $post[ 'cc' ] );
				}
				if ( $post[ 'action' ] == 'session-schedule' ) {
					echo schedule_report( $post[ 'name' ], $post[ 'title' ], $post[ 'sources' ], $post[ 'tower' ], $post[ 'customer' ], $post[ 'timeperiod' ], $post[ 'date' ], $post[ 'time' ], $post[ 'mode' ], $post[ 'to' ], $post[ 'cc' ] );
				}
				if ( $post[ 'action' ] == 'sql' ) {
					echo sql( $post[ 'sql' ], $post[ 'username' ], $post[ 'password' ] );
				}
				session_commit( );
				die( );
			}
			break;
		case 'GET' : 
			if ( isset( $_GET[ 'action' ] ) ) {
				if ( $_GET[ 'action' ] == 'get-config' ) {
					echo json_encode( get_config( ) );
				}
				if ( $_GET[ 'action' ] == 'get-session' ) {
					isset( $_SESSION[ 'sources' ] ) || $_SESSION[ 'sources' ] = array( );
					isset( $_SESSION[ 'tower' ] ) || $_SESSION[ 'tower' ] = '';
					isset( $_SESSION[ 'customer' ] ) || $_SESSION[ 'customer' ] = '';
					isset( $_SESSION[ 'timeperiod' ] ) || $_SESSION[ 'timeperiod' ] = '';
					echo json_encode( $_SESSION );
				}
				if ( $_GET[ 'action' ] == 'get-new-session' ) {
					$id = empty( $_GET[ 'name' ] ) ? session_id( ) : $_GET[ 'name' ];
					unset( $_SESSION[ 'config' ] );
					session_unset( );
					session_destroy( );
					session_id( $id );
					session_start( );
					echo json_encode( array( 'sources'=>array( ),'tower'=>'','customer'=>'','timeperiod'=>'', 'reload'=>'1' ) );
				}
				if ( $_GET[ 'action' ] == 'get-admin-config' ) {
					echo json_encode( get_admin_config( ) );
				}
				die( );
			}
			break;
	}
	if ( $_SERVER[ 'REQUEST_URI' ] != '/' ) {
		header( 'Location: /');
		exit;
	}
} catch ( ErrorException $e ) {
	if ( PHP_SAPI === 'cli' ) {
		$line = '%s: %s' . PHP_EOL;
	} else {
		$line = '<b>%s</b>: %s</br>' . PHP_EOL;
		echo '<div class="error">' . PHP_EOL;
	}
	echo sprintf( $line, 'Error', $e->getmessage( ) );
	echo sprintf( $line, 'Severity', $e->getseverity( ) );
	echo sprintf( $line, 'Code', $e->getcode( ) );
	echo sprintf( $line, 'File', $e->getfile( ) );
	echo sprintf( $line, 'Line', $e->getline( ) );
	if ( PHP_SAPI === 'cli' ) {
		$line = '%s: ' . PHP_EOL . '%s' . PHP_EOL;
		echo sprintf( $line, 'Trace', $e->gettraceasstring( ) );
	} else {
		$line = '<b>%s</b>: </br><code>%s</code></br>' . PHP_EOL;
		echo sprintf( $line, 'Trace', $e->gettraceasstring( ) );
		echo '</div>' . PHP_EOL;
	}
}
catch ( Exception $e ) {
	if ( PHP_SAPI === 'cli' ) {
		echo $e->getmessage( ) . PHP_EOL;
	} else {
		echo '<div class="error">' . PHP_EOL;
		echo $e->getmessage( ) . PHP_EOL;
		echo '</br>' . PHP_EOL;
		echo '</div>' . PHP_EOL;
	}
}
?>
