/**
 * 
 */

function getConfig( ) {
	$( 'ul#menu' ).find( 'li.dropdown' ).remove( );
	$( 'ul#right-menu li.dropdown' ).addClass( 'disabled' ).find( 'a.dropdown-toggle' ).prop( 'disabled', true );
	startTrack( function( ) {
		$.ajax( {
			url:  'php.php',
			type: 'GET',
			data: { action: 'get-config', format: 'json' },
			dataType: 'json'
		} )
		.always( stopTrack )
		.fail( ajaxError )
		.done( sessionStarted )
	} );
}

function fillSelect( id, items, selected ) {
	var $select = $( 'select#' + id ); 
	$.each( items, function( i, item ) {
		$select.append( $( '<option/>',{ 'value': item.name } ).append( item.name ) );
	} );
	$select.val( selected ).attr( 'onchange', 'selectChange(event)').removeClass( 'hidden' );
}

function sessionStarted( result ) {
	if ( typeof result === 'undefined' ) result = [ ];
	config = result;
	if ( config.error ) {
		showMessage( 'error', config.error );
		return false;
	}
	if ( config.classes.length > 0 ) {
		var styles = '';
		var $style = $( '#style' );
		$.each( config.classes, function( i, item ){
			styles += '.cl-' + i + ' { ' + item + ' }\n';
		} );
		$style.html( styles );
	}
	document.title = config.ini.SITE_NAME + ' - MARS Web interface';
	makeMenu( config.reports );
	makeUserMenu( 'user' );
	makeUserMenu( 'scheduled' );
	$( '<li/>' ).append( '-' ).appendTo( $( 'ul#menu' ) );
	fillSelect( 'tower-select', config.towers, tower );
	fillSelect( 'customer-select', config.customers, customer );
	fillSelect( 'timeperiod-select', config.timeperiods, timeperiod );
	iconifyCopyright( config.copyright );
	sessionLoad( );
}

function sessionLoad( event ) {
	if ( typeof event === 'object' ) {
		event.preventDefault( );
	}
	if ( arguments.length == 1 ) {
		var action  = 'get-new-session';
	} else {
		var action  = 'get-session';
	}
	startTrack( function( ) {
		$.ajax( {
		    url:  'php.php',
		    type: 'GET',
		    data: { action: action, format: 'json' },
		    dataType: 'json'
		} )
		.always( stopTrack )
		.fail( ajaxError )
		.done( sessionLoaded )
	} );
}
function sessionReload( event ){
	if ( typeof event === 'object' ) {
		event.preventDefault( );
	}
	location.replace( location.pathname );
}
function sessionStore( event ) {
	if ( typeof event === 'object' ) {
		event.preventDefault( );
	}
	startTrack( function( ) {
		$.ajax( {
		    url:  'php.php',
		    type: 'POST',
		    data: { 
		    	action: 'session-store',
		    	tower: tower,
		    	customer: customer,
		    	timeperiod: timeperiod,
		    	sources: JSON.stringify( sources )
		    }
		} )
		.always( stopTrack )
		.fail( ajaxError )
		.done( sessionStored )
	} );
}
function sessionStored( result ) {
//	showMessage( 'success', 'Session stored.' ); 
}
function sessionLoaded( result ) {
	sources = ( result.sources ) ? result.sources : [ ];
	tower = ( result.tower ) ? result.tower : 'All towers';
	customer = ( result.customer ) ? result.customer : 'All customers';
	timeperiod = ( result.timeperiod ) ? result.timeperiod : 'Last 7 days';
	if ( result.reload ) return sessionReload( );
	$( 'select#tower-select' ).val( tower );
	$( 'select#customer-select' ).val( customer );
	$( 'select#timeperiod-select' ).val( timeperiod );
	var $container = $( 'div#reports-container' );
	$container.empty( );
	$.each( sources, function( i, item ){ 
		$container.append( $( '<a/>', {id: item.name, name: item.name }  ) );
		sourceRefresh( item.name, 'no-data' ); 
	} );
//	showMessage( 'success', 'Session loaded.' );
	setTooltip( $( '.helpTooltip' ) );
}

function makeSubMenu( subMenu ) {
	var menuid = subMenu.replace( / /g, '_' ).toLowerCase( );
	var $subMenu = $( '<ul/>', { id:menuid, 'class': 'dropdown-menu' } );
	$( '<a/>', { id:menuid, 'data-toggle':'dropdown',	role:'button', 'class': 'helpTooltip dropdown-toggle' } )
		.append( subMenu )
		.append( $( '<span/>', { 'class': 'caret' } ) )
		.appendTo( $( '<li/>', { 'class': 'dropdown' } )
			.append( $subMenu )
			.appendTo( $( 'ul#menu' ) )
		);
	return $subMenu;
}
function makeMenu( reports ) {
	$.each( reports, function( i, item ) {
		if ( !item.category ) return;
		var id = item.category.replace( / /g, '_' ).toLowerCase( );
		var $subMenu = $( 'ul#' + id );
		if ( $subMenu.length == 0 ) $subMenu = makeSubMenu( item.category );
		if ( item.name == '---' ) {
			var $item = $( '<li/>', { role:'separator', 'class': 'divider' } );
		} else {
			var $item = $( '<li/>' );
			$item.append( $( '<a/>', { 
				href: '?report=' + item.name,
				'data-name': item.name, 
				text: item.title, 
				onclick: 'menuClickReport(event)' } )
			);
		}
		$item.appendTo( $subMenu );
	} );
}
function makeUserMenu( menu ) {
	var id = '';
	var reports = {};
	var icon = '';
	switch( menu ) {
		case 'user':
			var id = 'userReports';
			var reports = config.userreports;
			var icon = 'glyphicon-edit';
			break;
		case 'scheduled':
			var id = 'scheduledReports';
			var reports = config.scheduledreports;
			var icon = 'glyphicon-calendar';
			break;
	}
	if ( id == '' ) return;
	var $subMenu = $( 'ul#' + id );
	if ( $subMenu.length == 0 ) {
		var $subMenu = $( '<ul/>', { id:id, 'class': 'dropdown-menu' } );
		$( '<a/>', { id:id, 'data-toggle':'dropdown',	role: 'button', 'class': 'helpTooltip dropdown-toggle' } )
			.append( $( '<span/>',{ 'class': 'glyphicon ' + icon } ) )
			.append( $( '<span/>', { 'class': 'caret' } ) )
			.appendTo( $( '<li/>', { 'class': 'dropdown' } )
				.append( $subMenu )
				.appendTo( $( 'ul#menu' ) )
			);
	} else {
		$subMenu.find( 'li' ).remove( );
	}
	if ( reports.length == 0 ) $subMenu.parent( ).addClass( 'disabled' ).find( 'a.dropdown-toggle' ).prop( 'disabled', true );
	$.each( reports, function( i, item ) {
		var $item = $( '<li/>' );
		$item.append( $( '<a/>', { 
			href: '?report=' + item.name,
			'data-name': item.name, 
			text: item.title, 
			onclick: 'menuClickReport(event)' } )
		);
		$item.appendTo( $subMenu );
	} );
}

function menuClickReport( event ) {
	event.preventDefault( );
	var name = $( event.target ).data( 'name' );
//	history.pushState( null, null, location.pathname );
	var id = event.target.offsetParent.id;
	var coreReport = true;
	var reports = config.sources.filter( 
		function( i ){ return i.report == name; } );
	switch ( id ) {
		case 'userReports':
			var coreReport = false;
			var reports = config.userreports; 
			break; 
		case 'scheduledReports':
			var coreReport = false;
			var reports = config.scheduledreports; 
			break; 
	}
	var report = reports.find( 
		function( i ){ return i.name == name; } );
	if ( typeof report === 'undefined' ) return false;
	if ( coreReport ) {
		$.each( reports, function( i, item ) {
			sourceAdd( report.name, item.name );
			sourceRefresh( item.name, 'no-data' );
		} );
	} else {
		tower = ( report.tower ) ? report.tower : 'All towers';
		customer = ( report.customer ) ? report.customer : 'All customers';
		timeperiod = ( report.timeperiod ) ? report.timeperiod : 'Last 7 days';
		$( 'select#tower-select' ).val( tower );
		$( 'select#customer-select' ).val( customer );
		$( 'select#timeperiod-select' ).val( timeperiod );
		$.each( JSON.parse( report.sources ), function( i, item ) {
			sourceAdd( item.name, item.source );
			var source = sources.find( 
				function( i ){ return i.name == item.name; } );
			source.filters = item.filters;
			source.sorts = item.sorts;
			sourceRefresh( item.name, 'no-data' );
		} );
	}
//	showMessage( 'success', 'Report "' + report.title + '" added.' );
	return true;
}

function selectChange( event ) {
	event.preventDefault( );
	switch ( event.target.id ) {
		case 'tower-select': tower = $( event.target ).val( ); break; 
		case 'customer-select': customer = $( event.target ).val( ); break; 
		case 'timeperiod-select': timeperiod = $( event.target ).val( ); break; 
	}
	sessionStore( );
//	sessionReload( );
	$.each( sources, function( i, item ){
		sourceRefresh( item.name, 'no-data' );
	} );
	return true;
}
