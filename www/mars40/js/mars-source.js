/**
 * 
 */

function sourceAdd( reportName, sourceName ) {
	if ( typeof sourceName === 'undefined' ) sourceName = reportName;
	var found = false;
	$.each( sources, function( i, item ){
		if ( item.name == sourceName ) found = i;
	} );
	var origin = config.sources.find( 
			function( i ){ return i.report == reportName && i.name == sourceName; } );
	if ( found === false ) {
		var source = { };
		source.name = origin.name;
		source.source = origin.report;
		source.title = origin.title;
		source.description = origin.description;
		source.pivot = origin.pivot;
		source.fields = config.fields.filter( function( i ) {
			var result = origin.fields ? String( origin.fields ).match( '/(^|,)' + i.name + '(,|$)/g' ) : true;
			return i.source == origin.name && result;
		} );
		source.formats = config.formats.filter( 
//			function( i ) { return i.report == origin.report && i.source == origin.name; } );
			function( i ) { return RegExp( i.source ).test( origin.name ); } );
		source.links = config.links.filter( 
//			function( i ) { return i.report == origin.report && i.source == origin.name; } );
			function( i ) { return RegExp( i.source ).test( origin.name ); } );
		source.classes = config.classes;
		source.limit = origin.limit;
		source.tower = origin.tower;
		source.customer = origin.customer;
		source.timeperiod = origin.timeperiod;
		sources.push( source );
		var $a = $( '<a/>', {id: source.name, name: source.name }  );
	} else {
		source = sources[ found ];
		var $a = $( 'a#' + source.name );
	}
	$( 'div#reports-container' ).append( $a );
	source.filters = config.filters.filter(
//		function( i ) { return i.report == origin.report && i.source == origin.name; } );
		function( i ) { return RegExp( i.source ).test( origin.name ); } );
	source.sorts = config.sorts.filter( 
//		function( i ) { return i.report == origin.report && i.source == origin.name; } );
		function( i ) { return RegExp( i.source ).test( origin.name ); } );
	source.pagination = source.pivot == null ? 1 : 0;
	source.page = 1;
	source.highlight = 0;
	return source;
}

function sourceRemove( event ) {
	typeof event == 'object' && event.preventDefault( );
	var name = ( typeof event === 'object' ) ? $( event.target ).closest( 'div.panel' ).attr( 'id' ) : event;
	var found = false;
	$.each( sources, function( i, item ){
		if ( item.name == name ) found = i;
	} );
	if ( found !== false ) {
		$( 'a#' + name ).remove( );
		$( 'div#' + name ).remove( );
		sources.splice( found, 1 );
		if ( sources.length == 0 ) {
			$( 'ul#right-menu li.dropdown' ).addClass( 'disabled' ).find( 'a.dropdown-toggle' ).prop( 'disabled', true );
		}
		sessionStore( );
	}
	return found;
}
function sourceRefresh( name, mode ) {
	var source = sources.find( 
		function( i ){ return i.name == name; } );
	$( 'div#reports-container' ).find( 'div#' + name ).addClass( 'loading' ).find( 'span.badge.rows' ).text( 'Loading...' );
	startTrack( function( ) {
		$.ajax( {
		    url:  'php.php',
		    type: 'POST',
		    source: name,
		    mode: mode,
		    data: { action: 'source-show',
		    	tower: tower,
		    	customer: customer,
				timeperiod: timeperiod,
		    	mode: mode, 
		    	source: JSON.stringify( source )
		    }
		} )
		.always( function( ) { stopTrack( ); $( 'div#reports-container' ).find( 'div#' + name ).removeClass( 'loading' ); } )
		.done( function( data ){ sourceFill( this.source, this.mode, data ); } )
		.fail( ajaxError )
	} );
}
function sourceFill( name, mode, data ) {
	var source = sources.find( 
			function( i ){ return i.name == name; } );
	var $container = $( 'div#reports-container' );
	var $data = $.parseHTML( data );
	var href = '#' + source.name;
	switch ( mode ) {
		case 'no-data':
			$container.find( 'div' + href ).remove( );
			$( 'a' + href ).after( $data );
			var $source = $container.find( 'div' + href );
			$source.attr( 'class', 'panel panel-default' );
			var $div = $source.find( 'div.title' );
			$div.attr( 'class', 'panel-heading' );
			$div.prepend( $( '<span/>', { 'class':'glyphicon glyphicon-th' } ) );
			$div.append( $( '<button/>', { id:'remove', 'class': 'helpTooltip close', 
					type: 'button',
					onclick: 'sourceRemove(event)' } )
				.append( '&times;' )
			);
			var $div = $source.find( 'div.body' );
			$div.attr( 'class', 'panel-body' );
			var description = source.description;
			if ( source.tower == 1 && tower != 'All towers' ) description += ", for '<strong>" + tower + "</strong>' tower";
			if ( source.timeperiod == 1 ) description += ', for <strong>' + String( timeperiod ).toLowerCase( ) + '</strong>';
			if ( source.customer == 1 && customer != 'All customers' ) description += " and for customer '<strong>" + customer + "</strong>'";
			if ( source.filters.length == 0 ) description += ".";
			$div.find( 'div.description' )
				.empty( ) 
				.append( description )
				.append( $( '<span/>', { 'class':'filters' } ) )
				.append( $( '<span/>', { 'class':'sorts' } ) );
			$div.find( 'div.report' ).find( 'table' ).attr( 'class', 'table-hover text-nowrap' );
			var $div = $source.find( 'div.footer' );
			$div.attr( 'class', 'panel-footer' );
			var $pages = $( '<span/>' )
				.append( $( '<span/>', { id:'pagination', 'class': 'helpTooltip btn btn-hover btn-sm btn-default', onclick: 'sourcePage(event,0)' } )
				.append( $( '<span/>', { 'class': 'glyphicon glyphicon-list' } ) )
				.append( ' ' )
				.append( $( '<span/>', { 'class': 'text rows', text: 'Rows' } ) )
				.append( ' ' )
				.append( $( '<span/>', { 'class': 'badge rows', text: '0' } ) ) )
				.append( ' ' )
				.append( $( '<span/>', { 'class':'pages' } ) );
			$div.find( 'span.rows' ).empty( ).append( $pages );
			sourceShow( name, 'filters' );
			sourceShow( name, 'sorts' );
			sourceRefresh( name, 'data' );
			break;
		case 'data':
			var $source = $container.find( 'div' + href );
			$source.find( 'div.report' ).find( 'table' ).empty( ).append( data );
			var rows = 0;
			var links = { };
			var pivot = source.pivot == null ? [ ] : source.pivot.split( ',' );
			for( var i in source.fields ) {
				if( jQuery.inArray( source.fields[ i ].name, pivot ) !== -1 ) continue;
				links[ source.fields[ i ].name ] = source.fields[ i ].link; 
			}
			$.each( $source.find( 'div.report' ).find('tbody tr'), function( r, $row ){
				$.each( $( $row ).find( 'td' ), function( c, $cell ){
					if ( $( $cell ).text( ) == '' ) return;
					var i = pivot.length + ( c % ( source.fields.length - pivot.length ) );
					if ( source.fields[ i ].link ) {
						var description = String( source.fields[ i ].description );
						$.each( pivot, function( j, name ) {
							if ( j == 0 ) {
								var $th = $( $row ).find( 'th' );
							} else {
								var index = 0;
								var $th = null;
								$.each( $source.find( 'tr#' + name ).find( 'th' ), function( k, item ) {
									if ( k == 0 ) return;
						            var $th = index <= c ? item : $th;
									var colspan = $( item ).attr( 'colspan' );
						            var colspan = colspan ? parseInt( colspan ) : 1;
						            index += colspan;
								} );
							}
							var text = $( $th ).text( );
							description = description.replace( '%' + name + '%', text );
						} );
						$.each( source.fields, function( j, item ) {
							if ( jQuery.inArray( item.name, pivot ) !== -1 ) return;
							var $td = $( $row ).find( 'td' ).eq( j );
							var text = $( $td ).text( );
							description = description.replace( '%' + item.name + '%', text );
						} );
						$( $cell ).addClass( 'link' )
							.attr( 'data-link', source.fields[ i ].link )
							.attr( 'title', description )
							.attr( 'onclick', 'sourceLink(event)' );
					} 
				} );
				rows++;
			} );
			var $pages = $source.find( 'span.pages' );
			$pages.empty( );
			if ( source.pagination && rows == source.limit  ) {
				$pages.append( 'Pages: ' );
				var $pagination = $( '<ul/>', { 'class': 'pagination pagination-sm' } );
				var $page = $( '<li/>' ).append( $( '<a/>', { id:'prevpage', 'class':'helpTooltip', href: href } ).append( '&laquo;' ) );
				if ( source.page == 1 ) {
					$page.addClass( 'disabled' );
				} else {
					$page.attr( 'onclick', 'sourcePage( event, -1 )' );
				}
				$pagination.append( $page );
				for( i = 1; i <= source.page; i ++ ){
					var $page = $( '<li/>' ).append( $( '<a/>', { href: href, text: i } ) );
					if ( i == source.page ) { 
						$page.addClass( 'active' );
					} else {
						$page.attr( 'onclick', 'sourcePage( event )' )
					}
					$pagination.append( $page );
				}
				var $page = $( '<li/>' ).append( $( '<a/>', { id:'nextpage', 'class':'helpTooltip', href: href } ).append( '&raquo;' ) );
				if ( rows < source.limit ) {
					$page.addClass( 'disabled' ); 
				} else {
					$page.attr( 'onclick', 'sourcePage( event, 1 )' )
				}
				$pagination.append( $page );
				$pages.append( $pagination );
				var pagedRows = ( ( source.page - 1 ) * source.limit + 1 );
				var rows = rows == 0 ? 0 : pagedRows + ' - ' + ( pagedRows + rows - 1 );
		}
		$source.find( 'span.badge.rows' ).text( rows );
		$( 'ul#right-menu li.disabled' ).removeClass( 'disabled' ).find( 'a.dropdown-toggle' ).prop( 'disabled', false );
		break;
	} 
	setTooltip( $container.find( '.helpTooltip' ) );
}
function sourceShow( name, target ) {
	var source = sources.find( 
			function( i ){ return i.name == name; } );
	var $div = $( 'div#' + source.name ).find( 'span.' + target ); 
	$div.empty( );
	var join = '';
	var attr = { 
		'class': 'helpTooltip btn btn-sm btn-hover', 
		'title': 'Modify ' + target.slice(0, -1),
		'data-report': source.name, 
		'data-source': target, 
		'data-toggle': 'modal', 
		'data-target': '#modal'
	};
	switch ( target ) {
	case 'filters':
		if ( source.filters.length > 0 ) $div.append( ', where ' );
		$.each( source.filters, function( i, item ){
			$div.append( join );
			var field = arrayGet( source.fields, item.field );
			var operator = arrayGet( operators, item.operator );
			var value = item.value;
			attr[ 'data-id' ] = i + 1;
			var $item = $( '<span/>', attr )
				.append( $( '<span/>', { 'class': 'field', text: field } ) )
				.append( $( '<span/>', { 'class': 'operator', text: operator } ) )
				.append( '"' )
				.append( $( '<span/>', { 'class': 'value', text: value } ) )
				.append( '"' )
				.addClass( 'btn-default' );
			value == '' && $item.find( 'span.value' ).remove( );
			$div.append( $item );
			if ( join == '' ) join = ', ';
			if ( i == ( source.filters.length - 2 ) ) join = ' and '; 
		} );
		break;
	case 'sorts':
		if ( source.sorts.length > 0 ) $div.append( ', sorted by ' );
		$.each( source.sorts, function( i, item ){
			var field = arrayGet( source.fields, item.field );
			var sort = arrayGet( sorts, item.sort );
			attr[ 'data-id' ] = i + 1;
			var $item = $( '<span/>', attr )
				.append( $( '<span/>', { 'class': 'field', text: field } ) )
				.append( ' ' )
				.append( $( '<span/>', { 'class': 'sort', text: sort } ) )
				.addClass( 'btn-default' );
			$div.append( $item );
			if ( join == '' ) join = ', ';
			if ( i == ( source.sorts.length - 2 ) ) join = ' and '; 
		} );
		break;
	}
	$div.append( ' ' );
	attr[ 'data-id' ] = 'add';
	attr.title = 'Add new ' + target.slice(0, -1);
	var $item = $( '<span/>', attr )
		.append( $( '<span/>', { 'class' : 'glyphicon glyphicon-' + target.slice(0, -1) } ) )
		.append( '+' )
		.addClass( 'btn-primary' );
	$div.append( $item );
}
function sourcePage( event, page ) {
	event.preventDefault( );
	var name = $( event.target ).closest( 'div.panel' ).attr( 'id' );
	var source = sources.find( 
			function( i ){ return i.name == name; } );
	if ( source.pivot != null ) return true;
	if ( page == 0 ) {
		source.pagination = 1 - source.pagination;
		source.page = 1;
	} else {
		source.page = typeof page === 'undefined' ? parseInt( event.target.text ) : source.page + page;
	}
	sourceRefresh( source.name, 'data' );
}
function sourceLink( event ) {
	event.preventDefault( );
	var $td = $( event.target );
	var $tr = $td.parent( );
    var col = $tr.children( ).index( $td );
    var row = $tr.parent( ).children( ).index( $tr );
	var name = $td.closest( 'div.panel' ).attr( 'id' );
	var $container = $( 'div#reports-container' );
	var $source = $container.find( 'div#' + name );
	var source = sources.find( 
			function( i ){ return i.name == name; } );
	var pivot = [ ];
	var fieldIndex = col;
	if ( source.pivot != null ){
		pivot = source.pivot.split( ',' );
		fieldIndex = pivot.length + ( ( col - 1 ) % ( source.fields.length - pivot.length ) );
	}
	var field = source.fields[ fieldIndex ].name;
	var target = sourceAdd( $td.data( 'link' ) );
	sourceRefresh( target.name, 'no-data' );
	$.each( source.links, function( i, item ) {
		if( item.field == field && item.target == target.name ) {
			var value = item.value;
			$.each( target.filters, function( j, item1 ){
				if ( item1.field == item.filter ) target.filters.splice( j, 1 );
			} );
			$.each( source.fields, function( j, item1 ) {
				$.each( pivot, function( j, name ) {
					if ( j == 0 ) {
						var $th = $( $tr ).find( 'th' );
					} else {
						var index = 0;
						var $th = null;
						$.each( $source.find( 'tr#' + name ).find( 'th' ), function( k, item2 ) {
							if ( k == 0 ) return;
				            if ( index < col ) $th = item2;
							var colspan = $( item2 ).attr( 'colspan' );
				            colspan = colspan ? parseInt( colspan ) : 1;
				            index += colspan;
						} );
					}
					var text = $( $th ).text( );
					value = value.replace( '%' + name + '%', text );
				} );
				$.each( source.fields, function( j, item ) {
					if ( jQuery.inArray( item.name, pivot ) !== -1 ) return;
					var $td = $( $tr ).find( 'td' ).eq( j );
					var text = $( $td ).text( );
					value = value.replace( '%' + item.name + '%', text );
				} );
			} );
			target.filters.push( { field: item.filter, operator: item.operator, value: value } );
		}
	});
	$tr.closest( 'tbody' ).find( 'tr.highlight' ).removeClass( 'highlight' );
	$tr.addClass( 'highlight' );
	source.highlight = source.pagination * ( source.page - 1 ) * source.limit + row + 1;
	sourceShow( target.name, 'filters' );
	sourceRefresh( target.name, 'data' );
}
