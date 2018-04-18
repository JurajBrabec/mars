/**
 * 
 */
var config = [ ];
var sources = [ ];
var tower = 'All towers';
var customer = 'All customers';
var timeperiod = 'Last 7 days';
var sorts = [ 
	{ name: 'ASC', title: 'ascending' },
	{ name: 'DESC', title: 'descending' }
];
var operators = [
	{ name: 'REGEXP', title: 'matches' }, 
	{ name: 'NOT REGEXP', title: 'not match' }, 
	{ name: '=', title: 'is' }, 
	{ name: '!=', title: 'is not' }, 
	{ name: '<', title: 'is less than' }, 
	{ name: '>', title: 'is more than' }, 
	{ name: '<=', title: 'is less or equal than' }, 
	{ name: '>=', title: 'is equal or more than' } 
];
var _browser = {};

detectBrowser( );
if ( _browser.msie && _browser.version < 9 ) {
	var message = '<h3>This page requires <a href="https://jquery.com/browser-support/">JQuery 3.2</a></h2>';
	message += '<h5>To meet JQuery prerequisites, please upgrade <b>Internet Explorer</b> to version <b>9</b> or higher,';
	message += ' or use any other supported browser.</h5>';
	document.body.innerHTML = message;
}

if ( !Array.prototype.find ) {
	  Object.defineProperty( Array.prototype, 'find', {
		  value: function( predicate ) {
			  if ( this == null ) {
				  throw new TypeError( '"this" is null or not defined' );
			  }
			  var o = Object( this );
			  var len = o.length >>> 0;
			  if ( typeof predicate !== 'function' ) {
				  throw new TypeError( 'predicate must be a function' );
			  }
			  var thisArg = arguments[ 1 ];
			  var k = 0;
			  while ( k < len ) {
				  var kValue = o[ k ];
				  if ( predicate.call( thisArg, kValue, k, o ) ) {
					  return kValue;
				  }
				  k++;
			  }
			  return undefined;
		  }
	} );
}

function scrollFunction( ) {
	if (document.body.scrollTop > 75 || document.documentElement.scrollTop > 75) {
		document.getElementById("gotop").style.display = "block";
	} else {
		document.getElementById("gotop").style.display = "none";
	}
}

function goTop() {
	document.body.scrollTop = 0; // For Chrome, Safari and Opera 
	document.documentElement.scrollTop = 0; // For IE and Firefox
}

function arrayGet( where, what ){
	for ( var i in where ) {
		var item = where[ i ];
		if ( item.name == what ) return item.title;
		if ( item.title == what ) return item.name;
	}
}

function arrayDuplicate( where, what ) {
	var duplicate = false;
	for ( var i in where ) {
		var item = where[ i ];
		var dup = true;
		for ( var j in what ) {
			if ( item[ j ] != what[ j ] ) dup = false;
		}
		if ( dup ) duplicate = true;
	}
	return duplicate;
}

function showMessage( type, message ) {
	if ( typeof message  === 'undefined' ) {
		var message = type;
		var type = 'info';
	} 
	toastr.options = {
	  'closeButton': true,
	  'newestOnTop': true,
	  'progressBar': false,
	  'positionClass': 'toast-bottom-right',
	  'showDuration': '300',
	  'hideDuration': '1000',
	  'timeOut': '5000',
	  'extendedTimeOut': '1000',
	  'showEasing': 'swing',
	  'hideEasing': 'linear',
	  'showMethod': 'fadeIn',
	  'hideMethod': 'fadeOut',
	  'progressBar': false
	}
	toastr[ type ]( message );
}

function detectBrowser() {
  var uagent = navigator.userAgent.toLowerCase();
  var match = '';
    
  _browser.version = '';
  _browser.chrome  = /webkit/.test(uagent)  && /chrome/.test(uagent) && !/edge/.test(uagent);
  _browser.firefox = /mozilla/.test(uagent) && /firefox/.test(uagent);
  _browser.msie    = /msie/.test(uagent) || /trident/.test(uagent) || /edge/.test(uagent);
  _browser.safari  = /safari/.test(uagent)  && /applewebkit/.test(uagent) && !/chrome/.test(uagent);
  _browser.opr     = /mozilla/.test(uagent) && /applewebkit/.test(uagent) &&  /chrome/.test(uagent) && /safari/.test(uagent) && /opr/.test(uagent);
    
  for (x in _browser) {
    if (_browser[x]) {
      match = uagent.match(new RegExp("(" + (x === "msie" ? "msie|edge" : x) + ")( |\/)([0-9]+)"));
      if (match) {
        _browser.version = match[3];
      } else {
        match = uagent.match(new RegExp("rv:([0-9]+)"));
        _browser.version = match ? match[1] : "";
      }
    }
  }
  _browser.opera = _browser.opr;
  delete _browser.opr;
}

function ajaxError( result, status, error ) {
	showMessage( 'error', result.responseText + '. ' + status + ' : ' + error );
	return false;
}

function startTrack( func ) {
	trackCount = typeof trackCount == 'undefined' ? 1 : trackCount + 1;
	Pace.track( func );
}
function stopTrack() {
	trackCount = typeof trackCount == 'undefined' ? 0 : trackCount - 1;
	if ( trackCount == 0 ) Pace.stop( ); 
}

function iconifyCopyright( copyright ){
	var $c = $( 'div#copyright' );
	$c.html( copyright );
	$c.find( "strong:contains('MARS')" ).text( config.build ).prepend( $( '<img/>', { src:'img/mars-small.png' } ) );
	$c.find( "strong:contains('DXC')" ).prepend( $( '<img/>', { src:'img/dxc.png' } ) );
	$c.find( "strong:contains('HTML')" ).prepend( $( '<img/>', { src:'img/html5.png' } ) );
	$c.find( "strong:contains('CSS')" ).prepend( $( '<img/>', { src:'img/css3.png' } ) );
	$c.find( "strong:contains('JavaScript')" ).prepend( $( '<img/>', { src:'img/js.png' } ) );
	$c.find( "strong:contains('JQuery ')" ).prepend( $( '<img/>', { src:'img/jquery.png' } ) ).find( 'a' ).text('JQuery ' + $.fn.jquery );
	$c.find( "strong:contains('JQueryUI')" ).prepend( $( '<img/>', { src:'img/jqueryui.png' } ) ).find( 'a' ).text('JQueryUI ' + $.ui.version );
	$c.find( "strong:contains('Bootstrap')" ).prepend( $( '<img/>', { src:'img/bootstrap.png' } ) ).find( 'a' ).text( 'BootStrap ' + $.fn.button.Constructor.VERSION );
	$c.find( "strong:contains('PHP')" ).prepend( $( '<img/>', { src:'img/php5.png' } ) );
	$c.find( "strong:contains('MariaDB')" ).prepend( $( '<img/>', { src:'img/mariadb.png' } ) );
	$c.find( "strong:contains('Apache')" ).prepend( $( '<img/>', { src:'img/apache.png' } ) );
}

function addControl( label, icon, type, id, placeholder, value, focus ) {
	if ( typeof focus == 'undefined' ) focus = '';
	var $div = $( '<div/>', { 'class':'form-group' } );
	$div.append( $( '<label/>', { 'class': 'control-label col-sm-1' } ).append( label ) );
	$div.append( $( '<div/>', { 'class': 'col-sm-1' } ) );
	$div.append( $( '<div/>', { 'class': 'inputGroupContainer col-sm-10' } )
		.append( $( '<div/>', { 'class':'input-group' } )
			.append( $( '<span/>', { 'class': 'input-group-addon' } )
				.append( $( '<i/>', { 'class': 'glyphicon ' + icon } ) )
			)
			.append( $( '<input/>', { 'id': id, 'type': type, 'placeholder': placeholder, 'class': 'helpTooltip form-control' } )
				.addClass( focus )
				.val( value )
			)
		)
	);
	return $div;
}
function addRadio( label, name, values, value ) {
	var $div = $( '<div/>', { 'class':'form-group' } );
	$div.append( $( '<label/>', { 'class': 'control-label col-sm-1' } ).append( label ) );
	$div.append( $( '<div/>', { 'class': 'col-sm-1' } ) );
	var $div2 = $( '<div/>', { id:name, 'class': 'helpTooltip inputGroupContainer col-sm-5' } );
	$.each( values, function( i, item ){ 
		var $input = $( '<input/>', { type: 'radio', name:name, value: item } );
		$div2.append( $( '<label/>', { 'class': 'radio-inline' } ).append(  $input ).append( item ) );
		if ( item == value ) $input.prop( 'checked', 'checked' );
	} );
	$div.append( $div2 );
	return $div;
}
function addComboBox( label, icon, id, values, value ) {
	var $select = $( '<select/>', { id: id, 'class': 'helpTooltip form-control' } );
	$select.append( $( '<option/>',{ 'value': '' } ).append( '' ) );
	$.each( values, function( i, item ) {
		if ( item.obsoleted ) return;
		$select.append( $( '<option/>',{ 'value': item.name } ).append( item.name ) );
	} );
	$select.val( value );
	var $div = $( '<div/>', { 'class':'form-group' } );
	$div.append( $( '<label/>', { 'class': 'control-label col-sm-1' } ).append( label ) );
	$div.append( $( '<div/>', { 'class': 'col-sm-1' } ) );
	$div.append( $( '<div/>', { 'class': 'inputGroupContainer col-sm-5' } )
		.append( $( '<div/>', { 'class':'input-group' } )
			.append( $( '<span/>', { 'class': 'input-group-addon' } )
				.append( $( '<i/>', { 'class': 'glyphicon ' + icon } ) )
			)
			.append( $select )
		)
	);
	return $div;
}
function validate( control, value, message ) {
	var val = control.val( );
	control.parent( ).addClass( 'has-feedback' );
	if ( control.parent( ).find( 'span.form-control-feedback' ).length == 0 ) 
		control.parent( ).append( $( '<span/>', { 'class': 'glyphicon form-control-feedback' } ) );
	var icon = control.parent( ).find( 'span.form-control-feedback' );
	var result = false;
	if ( typeof value == 'undefined' ) {
		var result = true;
	}
	if ( typeof value == 'object' ) {
		var result = value instanceof RegExp ? result = value.test( val ) : !value.rows.find( function( i ){ return i[ value.field ] == val; } );
	} 
	if ( typeof value == 'string' ) {
		var result = value != val;
	}
	if ( result ) {
		control.focus( ).parent( ).removeClass( 'has-error' ).addClass( 'has-success' );
		icon.removeClass( 'glyphicon-remove' ).addClass( 'glyphicon-ok' );
	} else {
		control.focus( ).parent( ).removeClass( 'has-success' ).addClass( 'has-error' );
		icon.removeClass( 'glyphicon-ok' ).addClass( 'glyphicon-remove' );
		showMessage( 'error', message );
		val = false;
	}
	return val;
}

function setTooltip( obj ) {
	obj.tooltip( { 
		title: getText, 
		html: true, 
		placement: 'bottom'
	} );
}

function getText( ) {
	var helpText = '';
	var element = $( this );
	var id = element.attr( 'id' );
	$.ajax( {
		url: 'php.php',
		method: 'POST',
		async: false,
		data: { action: 'help', id:id },
		success: function( data ) { helpText = data; }
	} );   
	return helpText;
}

jQuery.loadScript = function ( url, callback ) {
	$.ajax( {
		url: url,
		dataType: 'script',
		async: true
	} )
	.fail( ajaxError )
	.done( callback )
}

jQuery( document ).ready( function( $ ) {
	window.onscroll = function( ) { scrollFunction( ) };
	$( 'a.navbar-brand' ).attr( 'href', location.pathname );
	if ( $( 'div#admin-container' ).length == 0 ) {
		$.loadScript( 'js/mars-source.js' );
		$.loadScript( 'js/mars-modal.js', function( ) { modalSetup( ); } );
		$.loadScript( 'js/mars-session.js', function( ) { getConfig( ); } );
	} else {
		$.loadScript( 'js/mars-admin.js', function( ) { getConfig( ); } );
	}
	setTooltip( $( '.helpTooltip' ) );
} );
