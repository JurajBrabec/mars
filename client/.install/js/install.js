var http = require( 'http' );
var fs = require( 'fs' );
var path = require( 'path' );
var root = path.resolve( __dirname, '../..' );
module.paths = [ path.resolve( root, 'bin/nodejs/node_modules' ) ];
var ini = require( 'ini' );
var StreamZip = require( 'node-stream-zip' );
var config = ini.parse( fs.readFileSync( path.resolve( root, '.install/install.ini' ), 'utf-8' ) )
console.log( 'Downloading client ...' );

var request = http.get( 'http://' + config.Mandatory.DB_HOST + '/nbu/client/install.zip', function( response ) {
	var fileName = path.resolve( root, 'tmp/install.zip' );
    if ( response.statusCode === 200 ) {
        var file = fs.createWriteStream( fileName );
        response.pipe( file );
		file.on( 'finish', function( ) {
			console.log( 'Client downloaded.' );
			extractZip( fileName );
		} );
	}
    request.setTimeout( 12000, function ( ) {
        request.abort( );
    } );
} );



function extractZip( fileName ) {
	console.log( 'Extracting client...' );
	var zip = new StreamZip( { file: fileName } );
	zip.on( 'ready', ( ) => {
		zip.extract( null, path.resolve( root ), ( err, count ) => {
			console.log( err ? 'Extract error.' : 'Extracted ' + count +' entries.' );
			zip.close( );
			fs.unlink( fileName );
			processFiles( );
		} );
	} );
}

function processFiles( ) {
	console.log( 'Processing config.ini ...' );
	var data = fs.readFileSync( path.resolve( root, '.install/conf/config.ini' ), 'utf-8' );
	data = data.replace( /%DB_HOST%/gim, config.Mandatory.DB_HOST );
	data = data.replace( /%TIME_ZONE%/gim, config.Mandatory.TIME_ZONE );
	data = data.replace( /%VERITAS_HOME%/gim, config.Mandatory.VERITAS_HOME );
	data = data.replace( /%VAULT_HOME%/gim, config.Mandatory.VAULT_HOME );
	data = data.replace( /%PHP_HOME%/gim, config.Optional.PHP_HOME );
	data = data.replace( /%NBU2ESL_PATH%/gim, config.Optional.NBU2ESL_PATH );
	data = data.replace( /""/gim, '"' );
	fs.writeFileSync( path.resolve( root, 'config.ini' ), data, 'utf-8' );

	console.log( 'Processing schtasks.xml ...' );
	var data = fs.readFileSync( path.resolve( root, '.install/conf/schtasks.xml' ), 'utf-8' );
	data = data.replace( /%AUTHOR%/gim, config.Optional.AUTHOR );
	data = data.replace( /%INTERVAL%/gim, config.Optional.INTERVAL );
	data = data.replace( /%MARS_ROOT%/gim, root );
	fs.writeFileSync( path.resolve( root, '.install/schtasks.xml' ), data, 'utf-8' );
	console.log( 'Done.' );
}
