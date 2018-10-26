/**
 * 
 */

function modalAdd( ) {
	var source = sources.find( 
			function( i ){ return i.name == $( '#modal-report' ).val( ); } );
	var target = $( '#modal-source' ).val( );
	switch ( target ) {
		case 'filters':
			var field = $( '#modal-field' ).val( );
			var operator = $( '#modal-operator' ).val( );
			var value = $( '#modal-value' ).val( ).trim( );
			var item = { field: field, operator: operator, value: value };
			if ( !arrayDuplicate( source.filters, item ) ) {
				source.filters.push( item );
			}
			break;
		case 'sorts':
			var field = $( '#modal-field' ).val( );
			var sort = $( '#modal-sort' ).val( );
			var item = { field: field, sort: sort };
			if ( !arrayDuplicate( source.sorts, item ) ) {
				source.sorts.push( item );
			}
			break;
	}
	$( 'div#modal' ).modal( 'hide' );
	showMessage( 'success', 'Report "' + source.title + '" ' + target + ' added' );
	sourceShow( source.name, target );
//	sourceRefresh( source.name, 'data' );
}
function modalUpdate( ) {
	var source = sources.find( 
			function( i ){ return i.name == $( '#modal-report' ).val( ); } );
	var target = $( '#modal-source' ).val( );
	var id = $( '#modal-id' ).val( ) - 1;
	switch ( target ) {
		case 'filters':
			var field = $( '#modal-field' ).val( );
			var operator = $( '#modal-operator' ).val( );
			var value = $( '#modal-value' ).val( ).trim( );
			var item = { field: field, operator: operator, value: value };
			if ( !arrayDuplicate( source.filters, item ) ) {
				source.filters[ id ] = item;
			}
			break;
		case 'sorts':
			var field = $( '#modal-field' ).val( );
			var sort = $( '#modal-sort' ).val( );
			var item = { field: field, sort: sort };
			if ( !arrayDuplicate( source.sorts, item ) ) {
				source.sorts[ id ] = item;
			}
			break;
	}
	$( 'div#modal' ).modal( 'hide' );
	showMessage( 'success', 'Report "' + source.title + '" ' + target + ' updated' );
	sourceShow( source.name, target );
//	sourceRefresh( source.name, 'data' );
}
function modalRemove( ) {
	var source = sources.find( 
			function( i ){ return i.name == $( '#modal-report' ).val( ); } );
	var target = $( '#modal-source' ).val( );
	var id = $( '#modal-id' ).val( ) - 1;
	switch( target ) {
		case 'filters':
			source.filters.splice( id, 1 );
			break;
		case 'sorts':
			source.sorts.splice( id, 1 );
			break;
	}
	$( 'div#modal' ).modal( 'hide' );
	showMessage( 'info', 'Report "' + source.title + '" ' + target + ' removed' );
	sourceShow( source.name, target );
//	sourceRefresh( source.name, 'data' );
}

function modalShow( event ) {
	$( 'div#modal' ).find( 'form' ).attr( 'class', 'form-inline' );
	var $button = $( event.relatedTarget );
	if ( typeof $button.data( 'report' ) == 'undefined' ) {
		return modalShowAlt( event );
	}
	var $body = $( 'div#modal' ).find( 'div.modal-body' ).empty( );
	var $footer = $( 'div#modal' ).find( 'div.modal-footer' ).empty( );
	var source = sources.find( 
			function( i ){ return i.name == $button.data( 'report' ); } );
	var target = $button.data( 'source' );
	var id = $button.data( 'id' );
	$( '#modal-title' ).text( target );
	$body.append( $( '<input/>', { 'id': 'modal-report', 'type': 'hidden' } ).val( source.name ) );
	$body.append( $( '<input/>', { 'id': 'modal-source', 'type': 'hidden' } ).val( target ) );
	$body.append( $( '<input/>', { 'id': 'modal-id', 'type': 'hidden' } ).val( id ) );
	switch( target ) {
		case 'filters':
			$( '#modal-icon' ).attr( 'class', 'glyphicon glyphicon-filter' );
			$body.append( 
				$( '<div/>', { 'class':'input-group input-group-sm' } )
					.append( $( '<span/>', { 'class': 'input-group-addon' } ).append( 'Where ' ) )
					.append( $( '<select/>', { 'id': 'modal-field' } ).addClass( 'helpTooltip form-control' ) )
				);
			$body.append( 
				$( '<div/>', { 'class':'input-group input-group-sm' } )
					.append( $( '<select/>', { 'id': 'modal-operator' } ).addClass( 'helpTooltip form-control' ) )
				);
			$body.append( 
				$( '<div/>', { 'class':'input-group input-group-sm' } )
					.append( $( '<input/>', { 'id': 'modal-value', 'type': 'text', 'placeholder': 'Enter value' } ).addClass( 'helpTooltip form-control focus' ) )
				);
			var $select = $( 'select#modal-field' )
			$.each( source.fields, function( key, item ) {
				$select.append( $( '<option/>' )
					.attr( 'value', item.name )
					.text( item.title )
				);
			} );
			var $select = $( 'select#modal-operator' )
			$.each( operators, function( key, item ) {
				$select.append( $( '<option/>' )
					.attr( 'value', item.name )
					.text( item.title )
				);
			} );
			if ( id === 'add' ) {
				$( '#modal-title' ).text( 'Add new filter' );
				$( '#modal-value').val( '' );
			} else {
				$( '#modal-title' ).text( 'Modify filter #' + id );
				$( '#modal-field' ).val( arrayGet( source.fields, $button.find( '.field' ).text( ) ) ); 
				$( '#modal-operator' ).val( arrayGet( operators, $button.find( '.operator' ).text( ) ) );
				$( '#modal-value').val( $button.find( '.value' ).text( ) );
			}
			break;
		case 'sorts':
			$( '#modal-icon' ).attr( 'class', 'glyphicon glyphicon-filter' );
			$body.append( 
				$( '<div/>', { 'class':'input-group input-group-sm' } )
					.append( $( '<span/>', { 'class': 'input-group-addon' } ).append( 'Sort by field ' ) )
					.append( $( '<select/>', { 'id': 'modal-field' } ).addClass( 'helpTooltip form-control' ) )
				);
			$body.append( 
				$( '<div/>', { 'class':'input-group input-group-sm' } )
					.append( $( '<select/>', { 'id': 'modal-sort' } ).addClass( 'helpTooltip form-control focus' ) )
				);
			var $select = $( 'select#modal-field' );
			$.each( source.fields, function( key, item ) {
				$select.append( $( '<option/>' )
					.attr( 'value', item.name )
					.text( item.title )
				);
			} );
			var $select = $( 'select#modal-sort' );
			$.each( sorts, function( key, item ) {
				$select.append( $( '<option/>' )
					.attr( 'value', item.name )
					.text( item.title )
				);
			} );
			if ( id === 'add' ) {
				$( '#modal-title' ).text( 'Add new sort' );
			} else {
				$( '#modal-title' ).text( 'Modify sort #' + id );
				$( '#modal-field' ).val( arrayGet( source.fields, $button.find( '.field' ).text( ) ) ); 
				$( '#modal-sort' ).val( arrayGet( sorts, $button.find( '.sort' ).text( ) ) );
			}
			break;
	}
	$footer.append( $( '<button/>', { id:'Close', 'type':'button', 'data-dismiss': 'modal' } )
			.addClass( 'helpTooltip btn btn-default' )
		.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-remove' ) )
		.append( ' Close' )
	);
	if ( id === 'add' ) {
		$footer.append( $( '<button/>', { 'id': 'modal-add', 'type':'button', 'class': 'helpTooltip btn btn-success', 'onclick': 'modalAdd( )' } )
			.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-ok' ) )
			.append( ' Add' )
		);
	} else {
		$footer.append( $( '<button/>', { 'id': 'modal-remove', 'type':'button', 'class': 'helpTooltip btn btn-danger', 'onclick': 'modalRemove( )' } )
			.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-trash' ) )
			.append( ' Remove' )
		);
		$footer.append( $( '<button/>', { 'id': 'modal-update', 'type':'button', 'class': 'helpTooltip btn btn-primary', 'onclick': 'modalUpdate( )' } )
			.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-ok' ) )
			.append( ' Update' )
		);
	}
	setTooltip( $( 'div#modal' ).find( '.helpTooltip' ) );
}

function modalSave( ) {
	var input = $( 'input#modal-title' );
	if ( !( title = validate( input, '', 'Name can\'t be empty.' ) ) ) return false;
	if ( !( title = validate( input, { rows:config.userreports, field:'title' }, 'User report with name "' + title + '" already exists.' ) ) ) return false;
	var name = String( title ).replace( / /g, '_' ).toLowerCase( );
	$( 'button#modal-save' ).text( 'Saving...' ).focus( ).prop( 'disabled', true );
	var userreports = [ ];
	$.each( sources, function( i, item ){
		var userreport = { };
		userreport.name = item.name;
		userreport.source = item.source;
		userreport.filters = item.filters;
		userreport.sorts = item.sorts;
		userreports.push( userreport );
	} );
	startTrack( function( ) {
		$.ajax( {
		    url:  'php.php',
		    type: 'POST',
		    data: { action: 'session-save',
		    	name: name,
		    	title: title,
		    	tower: tower == 'All towers' ? '' : tower,
		    	customer: customer == 'All customers' ? '' : customer,
				timeperiod: timeperiod,
		    	sources: JSON.stringify( userreports )
		    } 
		} )
		.always( function( ){ stopTrack( ); $( 'button#modal-save' ).text( 'Save' ).focus( ).prop( 'disabled', false ); } )
		.fail( ajaxError )
		.done( modalSaved )
	} );
}
function modalSend( ) {
	var title = '';
	var to = '';
	if ( !( title = validate( $( 'input#modal-title' ), '', 'Name can\'t be empty.' ) ) ) return false;
	var name = String( title ).replace( / /g, '_' ).toLowerCase( );
	if ( !( to = validate( $( 'input#modal-to' ), '', 'Recipient can\'t be empty.' ) ) ) return false;
	var mode = $( 'input[name=modal-mode]:checked' ).val( );
	var cc = validate( $( 'input#modal-cc' ) );
	$( 'button#modal-send' ).text( 'Sending...' ).focus( ).prop( 'disabled', true ); 
	startTrack( function( ) {
		$.ajax( {
		    url:  'php.php',
		    type: 'POST',
		    data: { action: 'session-send',
		    	sources: JSON.stringify( sources ),
		    	tower: tower == 'All towers' ? '' : tower,
	   	    	customer: customer == 'All customers' ? '' : customer,
		    	timeperiod: timeperiod,
		    	name: name,
		    	title: title,
		    	to: to,
		    	cc: cc,
		    	mode: mode
		    } 
		} )
		.always( function( ){ stopTrack( ); $( 'button#modal-send' ).text( 'Send' ).focus( ).prop( 'disabled', false ); } )
		.fail( ajaxError )
		.done( modalSent )
	} );
}
function modalSchedule( ) {
	var title = '';
	var to = '';
	var time = '';
	var input = $( 'input#modal-title' );
	if ( !( title = validate( input, '', 'Name can\'t be empty.' ) ) ) return false;
	if ( !( title = validate( input, { rows:config.scheduledreports, field:'title' }, 'Scheduled report with name "' + title + '" already exists.' ) ) ) return false;
	var name = String( title ).replace( / /g, '_' ).toLowerCase( );
	var input = $( 'input#modal-to' );
	if ( !( to = validate( input, '', 'Recipient can\'t be empty.' ) ) ) return false;
	var cc = validate( $( 'input#modal-cc' ) );
	var date = validate( $( 'input#modal-date' ) );
	var input = $( 'input#modal-time' );
	if ( !( time = validate( input, '', 'Time pattern can\'t be empty.' ) ) ) return false;
	var mode = $( 'input[name=modal-mode]:checked' ).val( );
	$( 'button#modal-schedule' ).text( 'Scheduling...' ).focus( ).prop( 'disabled', true );
	var scheduledreports = [ ];
	$.each( sources, function( i, item ){
		var scheduledreport = { };
		scheduledreport.name = item.name;
		scheduledreport.source = item.source;
		scheduledreport.filters = item.filters;
		scheduledreport.sorts = item.sorts;
		scheduledreports.push( scheduledreport );
	} );
	startTrack( function( ) {
		$.ajax( {
		    url:  'php.php',
		    type: 'POST',
		    data: { action: 'session-schedule',
		    	name: name,
		    	title: title,
		    	date: date,
		    	time: time,
		    	tower: tower == 'All towers' ? '' : tower,
	   	    	customer: customer == 'All customers' ? '' : customer,
				timeperiod: timeperiod,
		    	to: to,
		    	cc: cc,
		    	mode: mode,
		    	sources: JSON.stringify( scheduledreports )
		    } 
		} )
		.always( function( ){ stopTrack( ); $( 'button#modal-schedule' ).text( 'Schedule' ).focus( ).prop( 'disabled', false ); } )
		.fail( ajaxError )
		.done( modalScheduled )
	} );
}
function modalSaved( result ) {
	if ( result == 'OK' ) {
		$( 'div#modal' ).modal( 'hide' );
		showMessage( 'success', 'Report(s) successfuly saved.' );
		getConfig( );
	} else {
		showMessage( 'error', 'Error: ' + result );
	}
	return true;
}
function modalSent( result ) {
	if ( result == 'OK' ) {
		$( 'div#modal' ).modal( 'hide' );
		showMessage( 'success', 'Report(s) successfuly sent.' );
	} else {
		showMessage( 'error', 'Error: ' + result );
	}
	return true;
}
function modalScheduled( result ) {
	if ( result == 'OK' ) {
		$( 'div#modal' ).modal( 'hide' );
		showMessage( 'success', 'Report(s) successfuly scheduled.' );
	} else {
		showMessage( 'error', 'Error: ' + result );
	}
	return true;
}

function modalShowAlt( event ) {
	$( 'div#modal' ).find( 'form' ).attr( 'class', 'form-horizontal' );
	var $body = $( 'div#modal' ).find( 'div.modal-body' ).empty( );
	var $footer = $( 'div#modal' ).find( 'div.modal-footer' ).empty( );
	var id = event.relatedTarget.id;
	var name = '';
	$.each( sources, function( i, item ){ 
		name += ( name == '' ? '' : ' and ' ) + item.title; 
	} );
	name += ' report';
	$footer.append( $( '<button/>', { id:'Close', 'type':'button', 'data-dismiss': 'modal' } )
			.addClass( 'helpTooltip btn btn-default' )
		.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-remove' ) )
		.append( ' Close' )
	);
	var to = ''; 
	var cc = '';
	var date = '';
	var time = '';
	var mode = 'HTML';
	switch ( id ) {
		case 'save':
			$( '#modal-title' ).text( 'Save report(s)' );
			$( '#modal-icon' ).attr( 'class', 'glyphicon glyphicon-file' );
			$body.append( addControl( 'Name', 'glyphicon-file', 'text', 'modal-title', 'Report name', name, 'focus' ) );
			$footer.append( 
				$( '<button/>', { 'id': 'modal-save', 'type':'button', 'class': 'helpTooltip btn btn-success', 'onclick': 'modalSave( )' } )
					.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-file' ) )
					.append( ' Save' ) 
				);
			break;
		case 'send':
			$( '#modal-title' ).text( 'Send report(s)' );
			$( '#modal-icon' ).attr( 'class', 'glyphicon glyphicon-envelope' );
			$body.append( addControl( 'Name', 'glyphicon-file', 'text', 'modal-title', 'Report name', name, 'focus' ) );
			$body.append( addControl( 'To', 'glyphicon-envelope', 'mail', 'modal-to', 'Recipient list', to ) );
			$body.append( addControl( 'Cc', 'glyphicon-envelope', 'mail', 'modal-cc', 'Recipient list', cc ) );
			$body.append( addRadio( 'Mode', 'modal-mode', [ 'HTML', 'CSV' ], mode ) );
			$footer.append( $( '<button/>', { 'id': 'modal-send', 'type':'button', 'class': 'helpTooltip btn btn-success', 'onclick': 'modalSend( )' } )
				.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-envelope' ) )
				.append( ' Send' ) );
			break;
		case 'schedule':
			$( '#modal-icon' ).attr( 'class', 'glyphicon glyphicon-time' );
			$( '#modal-title' ).text( 'Schedule report(s)' );
			$body.append( addControl( 'Name', 'glyphicon-file', 'text', 'modal-title', 'Report name', name, 'focus' ) );
			$body.append( addControl( 'To', 'glyphicon-envelope', 'mail', 'modal-to', 'Recipient list', to ) );
			$body.append( addControl( 'Cc', 'glyphicon-envelope', 'mail', 'modal-cc', 'Recipient list', cc ) );
			$body.append( addRadio( 'Mode', 'modal-mode', [ 'HTML', 'CSV' ], mode ) );
			$body.append( addControl( 'Date', 'glyphicon-calendar', 'text', 'modal-date', 'Date pattern', date ) );
			$body.append( addControl( 'Time', 'glyphicon-time', 'text', 'modal-time', 'Time pattern', date ) );
			$footer.append( $( '<button/>', { 'id': 'modal-schedule', 'type':'button', 'class': 'helpTooltip btn btn-success', 'onclick': 'modalSchedule( )' } )
				.append( $( '<span/>' ).addClass( 'glyphicon glyphicon-time' ) )
				.append( ' Schedule' ) );
			break;
	}
	setTooltip( $( 'div#modal' ).find( '.helpTooltip' ) );
}

function modalFocus( event ) {
	$( this ).draggable( );
	$( this ).find( '.focus' ).focus( ); 
}

function modalSetup( ) {
	$( 'div#modal' ).on( 'show.bs.modal', modalShow );
	$( 'div#modal' ).on( 'shown.bs.modal', modalFocus );
}