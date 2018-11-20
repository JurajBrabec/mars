/**
 * 
 */

function getConfig( ) {
	startTrack( function( ) {
		$.ajax( {
			url:  'php.php',
			type: 'GET',
			data: { action: 'get-admin-config', format: 'json' },
			dataType: 'json'
		} )
		.always( stopTrack )
		.fail( ajaxError )
		.done( adminStarted )
	} );
}

function adminStarted( result ) {
	if ( typeof result === 'undefined' ) result = [ ];
	config = result;
	if ( config.error ) {
		showMessage( 'error', config.error );
		return false;
	}
	if ( typeof $( 'a#logout' ).attr( 'href' ) == 'undefined' ) {
		single = [ ];
		icon = [ ];
		document.title = config.ini.SITE_NAME + ' - MARS Admin interface';
		$.each( config.sources, function ( i, item ) {
			switch( item.name ) {
				case 'towers': single[ item.name ] = 'tower'; icon[ item.name ] = 'glyphicon-tower'; break;
				case 'customers': single[ item.name ] = 'customer'; icon[ item.name ] = 'glyphicon-user'; break;
				case 'timeperiods': single[ item.name ] = 'time period'; icon[ item.name ] = 'glyphicon-time'; break;
				case 'userreports': single[ item.name ] = 'user report'; icon[ item.name ] = 'glyphicon-edit'; break;
				case 'scheduledreports': single[ item.name ] = 'scheduled report'; icon[ item.name ] = 'glyphicon-calendar'; break;
				default: return false;
			}
			$( '<li/>', { 'class':'disabled' } )
			.append( $( '<a/>', { id: item.name, 'class': 'helpTooltip' } )
				.append( $( '<span/>',{ 'class': 'glyphicon ' + icon[ item.name ] } ) )
				.append( ' ' + item.title )
			)
			.appendTo( $( 'ul#menu' ) );
			
		} );
		iconifyCopyright( config.copyright );
		var loc = location.pathname.split( '/' ).slice( 0, -1 ).join( '/' );
		$( 'a#logout' ).attr( 'href', loc == '' ? '/' : loc );
		
	}
	adminSignIn( );
}

function adminSignIn( ) {
	if ( config.username != '' ) {
		return adminSignedIn( );
	}
	$( 'button#signin' ).attr( 'onclick', 'adminSignInClick(event)' );
	$( 'div#logon' ).modal( 'show' ).draggable( );
	$( 'input#username' ).focus( );
	isCookie( 'username' ) && $( 'input#username' ).val( getCookie( 'username' ) );
	isCookie( 'password' ) && $( 'input#password' ).val( window.atob( getCookie( 'password' ) ) );
}

function adminSignInClick( event ) {
	event.preventDefault( );
	if ( !( config.username = validate( $( 'input#username' ), '', 'User name can\'t be empty.' ) ) ) return false;
	if ( !( config.password = validate( $( 'input#password' ), '', 'Password can\'t be empty.' ) ) ) return false;
//	var sql = 'select * from mysql.user where user="' + config.username + '" and password=password("' + config.password + '");';
	var sql = 'select count(*) from config_customers;';
	$( 'button#signin' ).focus( ).prop( 'disabled', true ); 
	setCookie( 'username', config.username, 7 );
	setCookie( 'password', window.btoa( config.password ), 7 );
	startTrack( function( ) {
		$.ajax( {
		    url:  'php.php',
		    type: 'POST',
		    data: { action: 'sql',
		    	username: config.username,
		    	password: config.password,
		    	sql: sql
		    } 
		} )
		.always( function( ){ stopTrack( ); $( 'button#signin' ).focus( ).prop( 'disabled', false ); } )
		.fail( ajaxError )
		.done( adminSignInTest )
	} );
}

function adminSignInTest( result ) {
	if ( result == 'OK' ) {
		showMessage( 'success', 'Signed in, ' + config.username );
		$( 'div#logon' ).modal( 'hide' );
		getConfig( );
	} else {
		showMessage( 'error', 'Error: ' + result + '.' );
	}
	return true;
}

function adminSignedIn( ) {
	$( 'ul#menu li' ).removeClass( 'disabled' ).attr( 'onclick', 'adminClick(event)' );
	$( 'div#modal' ).on( 'show.bs.modal', adminModal );
	$( 'div#modal' ).on( 'shown.bs.modal', function() { $( this ).find( '.focus' ).focus( ); } );
	$.each( $( 'div#admin-container' ).find( 'div.panel' ), function( i, item ) {
		adminRefresh( $( item ).data( 'source' ) );
	} );
	$( 'button#nbu_event' )
		.removeAttr( 'disabled' )
		.removeClass( 'btn-default' )
		.addClass( config.event[ 0 ].status == 'ENABLED' ? 'btn-success' : 'btn-danger' )
		.prop( 'title', 'Last executed ' + config.routine_duration.updated )
		.find( 'span#duration' ).text( secToTime( config.routine_duration.value ) );
	$( 'button#nbu_maintenance' )
		.removeAttr( 'disabled' )
		.removeClass( 'btn-default' )
		.addClass( 'btn-primary' )
		.prop( 'title', 'Last executed ' + config.maintenance_duration.updated )
		.find( 'span#duration' ).text( secToTime( config.maintenance_duration.value ) );
	$( 'label#uploadfile span' ).removeClass( 'disabled' );
	$( 'label#uploadfile input' ).removeAttr( 'disabled' );
	$( document ).on( 'change', 'input#uploadfile', function( ) {
		$( 'input#filename' ).val( '' );
		$( 'label#upload button' ).attr( 'disabled', 'disabled' );
		var file = $( this )[ 0 ].files[ 0 ];
		if ( !file.name.match( /\.zip$/i ) ) {
			showMessage( 'error', 'File "' + file.name + '" is not a valid package.' );
			return false;
		}
		if ( file.size > 80*1024*1024 ) {
			showMessage( 'error', 'Package file size ' + Math.round( file.size / ( 1024 * 1024 ) ) + ' MB is too big.' );
			return false;
		}
		$( 'input#filename' ).val( file.name.replace( /\\/g, '/' ).replace( /.*\//, '' ) );
		$( 'label#upload button' ).removeAttr( 'disabled' );
		showMessage( 'Ready to upload the package.' );
	} );
	$( document ).on( 'click', 'button#nbu_event', function( ) {
		$( 'button#nbu_event' ).attr( 'disabled', 'disabled' ).removeClass( 'btn-success btn-danger' ).addClass( 'btn-default' );
		startTrack( function( ) {
			$.ajax( {
				url:  'php.php',
				type: 'POST',
				data: { action: 'sql',
					username: config.username,
					password: config.password,
					sql: 'CALL nbu_routine();'
				} 
			} )
			.always( function( ){ stopTrack( ); showMessage( 'Routine was executed.' ); } )
			.fail( ajaxError )
			.done( function( ){ 
				$( 'button#nbu_event' ).removeAttr( 'disabled' ).removeClass( 'btn-default' ).addClass( config.event[ 0 ].status == 'ENABLED' ? 'btn-success' : 'btn-danger' );
			} );
		} );
	} );
	$( document ).on( 'click', 'button#nbu_maintenance', function( ) {
		$( 'button#nbu_maintenance' ).attr( 'disabled', 'disabled' ).removeClass( 'btn-success btn-danger' ).addClass( 'btn-default' );
		startTrack( function( ) {
			$.ajax( {
				url:  'php.php',
				type: 'POST',
				data: { action: 'sql',
					username: config.username,
					password: config.password,
					sql: 'CALL nbu_maintenance();'
				} 
			} )
			.always( function( ){ stopTrack( ); showMessage( 'Maintenance was executed.' ); } )
			.fail( ajaxError )
			.done( function( ){ 
				$( 'button#nbu_maintenance' ).removeAttr( 'disabled' ).removeClass( 'btn-default' ).addClass( 'btn-primary' );
			} );
		} );
	} );
	$( document ).on( 'click', 'button#upload', function( ) {
		$( 'label#upload button' ).attr( 'disabled', 'disabled' );
		var file = $( 'label#uploadfile input' )[ 0 ].files[ 0 ];
		var data = new FormData( );
		data.append( 'action', 'upload' );
		data.append( 'file', file );
		startTrack( function( ) {
			$.ajax( {
				url:  'php.php',
				type: 'POST',
				data: data,
				cache: false,
				contentType: false,
				processData: false
			} )
			.fail( ajaxError )
			.done( function( result ){
				result = result.replace( new RegExp( '(succes[a-z]+)', 'g' ), '<span class="btn-success">$1</span>' ) ;
				result = result.replace( new RegExp( '(error)', 'g' ), '<span class="btn-warning">$1</span>' ) ;
				result = result.replace( new RegExp( '(fail[a-z]+)', 'g' ), '<span class="btn-error">$1</span>' ) ;
				$( 'div#upload' ).append( '<pre>' + result + '</pre>' );
			} )
		} );
	} );
	setTooltip( $( '.helpTooltip' ) );
}

function adminClick( event ) {
	event.preventDefault( );
	var name = event.target.id;
	var source = config.sources.find( 
		function( i ){ return i.name == name; } );
	var $panel = $( '<div/>', { 'class': 'panel panel-default', 'data-source': source.name } )
		.append( $( '<div/>', { 'class': 'panel-heading' } )
			.append( $( '<span/>', { 'class':'glyphicon ' + icon[ name ] } ) )
			.append( source.title ) )
		.append( $( '<div/>', { 'class': 'panel-body' } )
		.append( $( '<div/>', { 'class': 'panel-footer' } ) ) );
	$( 'div#admin-container' ).empty( ).append( $panel );	
	adminRefresh( name );
}

function adminRefresh( name ) {
	var source = config.sources.find( 
			function( i ){ return i.name == name; } );
	var fields = config.fields.filter( 
			function( i ){ return i.source == name; } );
	var rows = config[ name ];
	var attr = {
		id: 'Add',
		'data-row': -1,
		type: 'button',
		'class': 'helpTooltip btn btn-xs',
		'data-toggle': 'modal', 
		'data-target': '#modal'
	}
	var $table = $( '<table/>', { 'class': 'table-hover text-nowrap' } );
	var $add = $( '<button/>', attr )
		.addClass( 'btn-success' )
		.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-plus' ) );
	if ( name.match( /user|schedule/i ) ) $add.prop( 'disabled', true );
	attr.id = 'Update';
	var $update = $( '<button/>', attr )
		.addClass( 'btn-primary' )
		.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-edit' ) );
	var $tr = $( '<tr/>' ).append( $( '<th/>' ).append( $add ) );
	$.each( fields, function( i, item ) {
		$tr.append( $( '<th/>' ).append( item.title ) );
	} );
	$table.append( $( '<thead/>' ).append( $tr ) );
	var $body = $( '<tbody/>' );
	var time = new Date( ).getTime() - 5*60*1000;
	$.each( rows, function( i, row ){
		var $tr = $( '<tr/>' );
		var updated = new Date( row.updated ).getTime( );
		if ( row.obsoleted != null ) $tr.addClass( 'obsoleted' );
		if ( updated > time ) $tr.addClass( 'updated' );
		$tr.append( $( '<th/>' ).append( $update.clone( ).data( 'row', i ) ) );
		$.each( row , function ( j, item ) {
			if ( j == 'sources' ) return;
			var $td = $( '<td/>' ).append( item );
			if ( j.match( /create|update|obsolete/i ) ) $td.addClass(  'readonly' );
			$tr.append( $td );
		} );
		$body.append( $tr );
	} );
	$table.append( $body );
	setTooltip( $table.find( '.helpTooltip' ) );
	$( 'div.panel-body' )
		.empty( )
		.append( $( '<div/>', { 'class': 'description' } ).append( source.description ) )
		.append( $( '<div/>', { 'class': 'report' } ).append( $table ) );
}

function adminModal( event ) {
	$( 'div#modal' ).draggable( ).find( 'form' ).attr( 'class', 'form-horizontal' );
	var $button = $( event.relatedTarget );
	var name = $button.parents( 'div.panel' ).data( 'source' );
	var $body = $( 'div#modal' ).find( 'div.modal-body' ).empty( );
	var $footer = $( 'div#modal' ).find( 'div.modal-footer' ).empty( );
	$footer.append( $( '<button/>', { id:'Close', 'type':'button', 'data-dismiss': 'modal' } )
			.addClass( 'helpTooltip btn btn-default' )
		.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-remove' ) )
		.append( ' Close' )
	);
	var source = config.sources.find( 
			function( i ){ return i.name == name; } );
	var fields = config.fields.filter( 
			function( i ){ return i.source == name; } );
	var row = config[ name ][ $button.data( 'row' ) ];
	var action = $button.attr( 'id' );
	$( '#modal-title' ).text( action + ' ' + single[ name ] );
	$( '#modal-icon' ).attr( 'class', 'glyphicon ' + icon[ name ] );
	$body.append( $( '<input/>', { 'id': 'source', 'type': 'hidden' } ).val( name ) );
	switch ( name ) {
		case 'towers':
//			var modalname = typeof row == 'undefined' ? '' : row.name;
//			var modalpolicyname = typeof row == 'undefined' ? '' : row.policyname;
			var modalname = typeof row == 'undefined' ? getCookie( 'name' ) : row.name;
			var modalpolicyname = typeof row == 'undefined' ? getCookie( 'policyname' ) : row.policyname;
			var table = 'config_towers';
			var fields = 'name,policyname';
			var values = '"%name","%policyname"';
			var set = 'name="%name",policyname="%policyname"';
			var key = 'name="' + modalname + '"';
			$body.append( addControl( 'Name', 'glyphicon-file', 'text', 'modal-name', 'Tower name', modalname, 'focus' ) );
			$body.append( addControl( 'Policy', 'glyphicon-eye-open', 'text', 'modal-pattern', 'Policy name pattern', modalpolicyname ) );
			break;
		case 'customers':
//			var modalname = typeof row == 'undefined' ? '' : row.name;
//			var modalpolicyname = typeof row == 'undefined' ? '' : row.policyname;
			var modalname = typeof row == 'undefined' ? getCookie( 'name' ) : row.name;
			var modalpolicyname = typeof row == 'undefined' ? getCookie( 'policyname' ) : row.policyname;
			var table = 'config_customers';
			var fields = 'name,policyname';
			var values = '"%name","%policyname"';
			var set = 'name="%name",policyname="%policyname"';
			var key = 'name="' + modalname + '"';
			$body.append( addControl( 'Name', 'glyphicon-file', 'text', 'modal-name', 'Customer name', modalname, 'focus' ) );
			$body.append( addControl( 'Policy', 'glyphicon-eye-open', 'text', 'modal-pattern', 'Policy name pattern', modalpolicyname ) );
			break;
		case 'timeperiods':
//			var modalord = typeof row == 'undefined' ? '' : row.ord;
//			var modalname = typeof row == 'undefined' ? '' :  row.name;
//			var modalvalue = typeof row == 'undefined' ? '' : row.value;
			var modalord = typeof row == 'undefined' ? getCookie( 'ord' ) : row.ord;
			var modalname = typeof row == 'undefined' ? getCookie( 'name' ) : row.name;
			var modalvalue = typeof row == 'undefined' ? getCookie( 'value' ) : row.value;
			var table = 'config_timeperiods';
			var fields = 'ord,name,value';
			var values = '"%ord","%name","%value"';
			var set = 'ord="%ord",name="%name",value="%value"';
			var key = 'name="' + modalname + '"';
			$body.append( addControl( 'Order', 'glyphicon-sort-by-attributes', 'text', 'modal-ord', 'Order', modalord, '' ) );
			$body.append( addControl( 'Name', 'glyphicon-file', 'text', 'modal-name', 'Time period name', modalname, 'focus' ) );
			$body.append( addControl( 'Code', 'glyphicon-barcode', 'text', 'modal-value', 'Time period code', modalvalue, '' ) );
			break;
		case 'userreports':
			var modalsources = typeof row == 'undefined' ? '' : row.sources;
//			var modaltitle = typeof row == 'undefined' ? '' : row.title;
//			var modaltower = typeof row == 'undefined' ? '' : row.tower;
//			var modalcustomer = typeof row == 'undefined' ? '' : row.customer;
//			var modaltimeperiod = typeof row == 'undefined' ? '' : row.timeperiod;
			var modaltitle = typeof row == 'undefined' ? getCookie( 'title' ) : row.title;
			var modaltower = typeof row == 'undefined' ? getCookie( 'tower' ) : row.tower;
			var modalcustomer = typeof row == 'undefined' ? getCookie( 'customer' ) : row.customer;
			var modaltimeperiod = typeof row == 'undefined' ? getCookie( 'timeperiod' ) : row.timeperiod;
			var table = 'config_reports';
			var fields = 'title,name,tower,customer,timeperiod,sources';
			var values = '"%title","%name",nullif("%tower",""),nullif("%customer",""),nullif("%timeperiod",""),"%sources"';
			var set = 'title="%title",name="%name",tower=nullif("%tower",""),customer=nullif("%customer",""),timeperiod=nullif("%timeperiod","")';
			var key = 'title="' + modaltitle + '"';
			$body.append( $( '<input/>', { 'id': 'modal-sources', 'type': 'hidden' } ).val( modalsources ) );
			$body.append( addControl( 'Name', 'glyphicon-file', 'text', 'modal-title', 'Report name', modaltitle, 'focus' ) );
			$body.append( addComboBox( 'Tower', 'glyphicon-tower', 'modal-tower', config.towers, modaltower ) );
			$body.append( addComboBox( 'Customer', 'glyphicon-user', 'modal-customer', config.customers, modalcustomer ) );
			$body.append( addComboBox( 'Timeperiod', 'glyphicon-time', 'modal-timeperiod', config.timeperiods, modaltimeperiod ) );
			break;
		case 'scheduledreports':
			var modalsources = typeof row == 'undefined' ? '' : row.sources;
//			var modaldate = typeof row == 'undefined' ? '' : row.date;
//			var modaltime = typeof row == 'undefined' ? '' : row.time;
//			var modaltitle = typeof row == 'undefined' ? '' : row.title;
//			var modaltower = typeof row == 'undefined' ? '' : row.tower;
//			var modalcustomer = typeof row == 'undefined' ? '' : row.customer;
//			var modaltimeperiod = typeof row == 'undefined' ? '' : row.timeperiod;
//			var modalmode = typeof row == 'undefined' ? '' : row.mode;
//			var modalto = typeof row == 'undefined' ? '' : row.to;
//			var modalcc = typeof row == 'undefined' ? '' : row.cc;
			var modaldate = typeof row == 'undefined' ? getCookie( 'date' ) : row.date;
			var modaltime = typeof row == 'undefined' ? getCookie( 'time' ) : row.time;
			var modaltitle = typeof row == 'undefined' ? getCookie( 'title' ) : row.title;
			var modaltower = typeof row == 'undefined' ? getCookie( 'tower' ) : row.tower;
			var modalcustomer = typeof row == 'undefined' ? getCookie( 'customer' ) : row.customer;
			var modaltimeperiod = typeof row == 'undefined' ? getCookie( 'timeperiod' ) : row.timeperiod;
			var modalmode = typeof row == 'undefined' ? getCookie( 'mode' ) : row.mode;
			var modalto = typeof row == 'undefined' ? getCookie( 'to' ) : row.to;
			var modalcc = typeof row == 'undefined' ? getCookie( 'cc' ) : row.cc;
			var table = 'config_schedules';
			var fields = '`date`,`time`,title,name,tower,customer,timeperiod,mode,`to`,cc,sources';
			var values = 'nullif("%date",""),"%time","%title","%name",nullif("%tower",""),nullif("%customer",""),nullif("%timeperiod",""),"%mode","%to",nullif("%cc",""),"%sources"';
			var set = '`date`=nullif("%date",""),`time`="%time",title="%title",name="%name",tower=nullif("%tower",""),customer=nullif("%customer",""),timeperiod=nullif("%timeperiod",""),mode="%mode",`to`="%to",cc=nullif("%cc","")';
			var key = 'title="' + modaltitle + '"';
			$body.append( $( '<input/>', { 'id': 'modal-sources', 'type': 'hidden' } ).val( modalsources ) );
			$body.append( addControl( 'Name', 'glyphicon-file', 'text', 'modal-title', 'Report name', modaltitle, 'focus' ) );
			$body.append( addComboBox( 'Tower', 'glyphicon-tower', 'modal-tower', config.towers, modaltower ) );
			$body.append( addComboBox( 'Customer', 'glyphicon-user', 'modal-customer', config.customers, modalcustomer ) );
			$body.append( addComboBox( 'Timeperiod', 'glyphicon-time', 'modal-timeperiod', config.timeperiods, modaltimeperiod ) );
			$body.append( addControl( 'To', 'glyphicon-envelope', 'mail', 'modal-to', 'Recipient list', modalto ) );
			$body.append( addControl( 'Cc', 'glyphicon-envelope', 'mail', 'modal-cc', 'Recipient list', modalcc ) );
			$body.append( addRadio( 'Mode', 'modal-mode', [ 'HTML', 'CSV' ], modalmode ) );
			$body.append( addControl( 'Date', 'glyphicon-barcode', 'text', 'modal-date', 'Schedule date pattern', modaldate ) );
			$body.append( addControl( 'Time', 'glyphicon-barcode', 'text', 'modal-time', 'Schedule time pattern', modaltime ) );
			break;
	}
	var sqla = 'insert into %table (%fields) values(%values);'
		.replace( /%table/g, table )
		.replace( /%fields/g,fields )
		.replace( /%values/g, values );
	var sqlu = 'update %table set %set,obsoleted=null where %key;'
		.replace( /%table/g, table )
		.replace( /%set/g,set )
		.replace( /%key/g, key );
	var sqld = 'update %table set obsoleted=now() where %key;'
		.replace( /%table/g, table )
		.replace( /%key/g, key );
	$body.append( $( '<input/>', { 'id': 'sqla', 'type': 'hidden' } ).val( sqla ) );
	if ( action == 'Add' ) {
		$footer.append( 
			$( '<button/>', { id:'add', 'type':'button', 'class': 'helpTooltip btn btn-success', 'onclick': 'adminAction("add")' } )
				.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-ok' ) )
				.append( ' Add' ) 
			);
	} else {
		$body.append( $( '<input/>', { 'id': 'sqlu', 'type': 'hidden' } ).val( sqlu ) );
		$body.append( $( '<input/>', { 'id': 'sqld', 'type': 'hidden' } ).val( sqld ) );
		$footer.append( 
			$( '<button/>', { id:'upd', 'type':'button', 'class': 'helpTooltip btn btn-success', 'onclick': 'adminAction("upd")' } )
				.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-ok' ) )
				.append( ' Update' ) 
			);
		$footer.append( 
			$( '<button/>', { id:'add', 'type':'button', 'class': 'helpTooltip btn btn-warning', 'onclick': 'adminAction("add")' } )
				.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-plus' ) )
				.append( ' Clone' ) 
			);
		$footer.append( 
			$( '<button/>', { id:'del', 'type':'button', 'class': 'helpTooltip btn btn-danger', 'onclick': 'adminAction("del")' } )
				.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-trash' ) )
				.append( ' Delete' ) 
			);
		if ( row.obsoleted ) $( 'button#del' ).prop( 'disabled', true );
	}
	setTooltip( $( 'div#modal' ).find( '.helpTooltip' ) );
}

function adminAction( action ) {
	var sql = '';
	switch ( action ) {
		case 'add': sql = $( '#sqla' ).val( ); break;
		case 'upd': sql = $( '#sqlu' ).val( ); break;
		case 'del': sql = $( '#sqld' ).val( ); break;
	}
	var name = $( 'input#source' ).val( );
	switch( name ) {
		case 'towers':
		case 'customers':
			var modalname = '';
			var modalpolicyname = '';
			if ( !( modalname = validate( $( 'input#modal-name' ), '', 'Name can\'t be empty.' ) ) ) return false;
			if ( action == 'add' && !( modalname = validate( $( 'input#modal-name' ), { rows:config[ name ], field:'name' }, 'Name "' + modalname + '" already exists.' ) ) ) return false;
			if ( !( modalpolicyname = validate( $( 'input#modal-pattern' ), '', 'Policy name pattern can\'t be empty.' ) ) ) return false;
			modalpolicyname = modalpolicyname.replace( /\\/g, '\\\\' );
			setCookie( 'name', modalname );			
			setCookie( 'policyname', modalpolicyname );
			var sql = sql
				.replace( /%name/g, modalname )
				.replace( /%policyname/g, modalpolicyname );
			break;
		case 'timeperiods':
			var modalord = '';
			var modalname = '';
			var modalvalue = '';
			if ( !( modalord = validate( $( 'input#modal-ord' ), '', 'Order can\'t be empty.' ) ) ) return false;
			if ( !( modalname = validate( $( 'input#modal-name' ), '', 'Name can\'t be empty.' ) ) ) return false;
			if ( action == 'add' && !( modalname = validate( $( 'input#modal-name' ), { rows:config[ name ], field:'name' }, 'Name "' + modalname + '" already exists.' ) ) ) return false;
			if ( !( modalvalue = validate( $( 'input#modal-value' ), '', 'Code can\'t be empty.' ) ) ) return false;
			if ( !( modalvalue = validate( $( 'input#modal-value' ), /(H|D|W|M|N|Y)((\+|\-)\d)?::(H|D|W|M|N|Y)((\+|\-)\d)?/g, 'Invalid code format.' ) ) ) return false;
			setCookie( 'ord', modalord );			
			setCookie( 'name', modalname );
			setCookie( 'value', modalvalue );
			var sql = sql
				.replace( /%ord/g, modalord )
				.replace( /%name/g, modalname )
				.replace( /%value/g, modalvalue );
			break;
		case 'userreports':
			var modaltitle = '';
			if ( !( modaltitle = validate( $( 'input#modal-title' ), '', 'Name can\'t be empty.' ) ) ) return false;
			if ( action == 'add' && !( modaltitle = validate( $( 'input#modal-title' ), { rows:config[ name ], field:'title' }, 'Name "' + modaltitle + '" already exists.' ) ) ) return false;
			var modalname = String( modaltitle ).replace( / /g, '_' ).toLowerCase( );
			var modaltower = $( 'select#modal-tower option:selected' ).text( );
			var modalcustomer = $( 'select#modal-customer option:selected' ).text( );
			var modaltimeperiod = $( 'select#modal-timeperiod option:selected' ).text( );
			var modalsources = $( 'input#modal-sources' ).val( ).replace( /\"/g, '\\"' );
			setCookie( 'title', modaltitle );			
			setCookie( 'tower', modalmode );
			setCookie( 'customer', modalmode );
			setCookie( 'timeperiod', modalmode );
			sql = sql
				.replace( /%name/g, modalname )
				.replace( /%title/g, modaltitle )
				.replace( /%tower/g, modaltower )
				.replace( /%customer/g, modalcustomer )
				.replace( /%timeperiod/g, modaltimeperiod )
				.replace( /%sources/g, modalsources );
			break;
		case 'scheduledreports':
			var modaltitle = '';
			var modalto = '';
			var modaltime = '';
			if ( !( modaltitle = validate( $( 'input#modal-title' ), '', 'Name can\'t be empty.' ) ) ) return false;
			if ( action == 'add' && !( modaltitle = validate( $( 'input#modal-title' ), { rows:config[ name ], field:'title' }, 'Name "' + modaltitle + '" already exists.' ) ) ) return false;
			var modalname = String( modaltitle ).replace( / /g, '_' ).toLowerCase( );
			var modaltower = $( 'select#modal-tower option:selected' ).text( );
			var modalcustomer = $( 'select#modal-customer option:selected' ).text( );
			var modaltimeperiod = $( 'select#modal-timeperiod option:selected' ).text( );
			var modalmode = $( 'input[name=modal-mode]:checked' ).val( );
			if ( !( modalto = validate( $( 'input#modal-to' ), '', 'Recipient can\'t be empty.' ) ) ) return false;
			var modalcc = validate( $( 'input#modal-cc' ) );
			var modaldate = validate( $( 'input#modal-date' ) ).replace( /\\/g, '\\\\' );
			if ( !( modaltime = validate( $( 'input#modal-time' ), '', 'Time pattern can\'t be empty.' ) ) ) return false;
			var modalsources = $( 'input#modal-sources' ).val( ).replace( /\"/g, '\\"' );
			var modaltime = modaltime.replace( /\\/g, '\\\\' );
			setCookie( 'date', modaldate );
			setCookie( 'time', modaltime );
			setCookie( 'title', modaltitle );			
			setCookie( 'tower', modalmode );
			setCookie( 'customer', modalmode );
			setCookie( 'timeperiod', modalmode );
			setCookie( 'mode', modalmode );
			setCookie( 'to', modalto );
			setCookie( 'cc', modalcc );
			var sql = sql
				.replace( /%date/g, modaldate )
				.replace( /%timeperiod/g, modaltimeperiod )
				.replace( /%name/g, modalname )
				.replace( /%title/g, modaltitle )
				.replace( /%tower/g, modaltower )
				.replace( /%customer/g, modalcustomer )
				.replace( /%time/g, modaltime )
				.replace( /%mode/g, modalmode )
				.replace( /%to/g, modalto )
				.replace( /%cc/g, modalcc )
				.replace( /%sources/g, modalsources );
			break;
	}
	$( 'button#' + action ).focus( ).prop( 'disabled', true );
	startTrack( function( ) {
		$.ajax( {
		    url:  'php.php',
		    type: 'POST',
		    data: { action: 'sql',
		    	username: config.username,
		    	password: config.password,
		    	sql: sql
		    } 
		} )
		.always( function( ){ stopTrack( ); $( 'button#' + action ).focus( ).prop( 'disabled', false ); } )
		.fail( ajaxError )
		.done( adminDone )
	} );
}

function adminDone( result ) {
	if ( result == 'OK' ) {
		$( 'div#modal' ).modal( 'hide' );
		getConfig( );
	} else {
		showMessage( 'error', 'Error: ' + result + '.' );
	}
	return true;
}

