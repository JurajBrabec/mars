var fs = require( 'fs' );
var path = require( 'path' );
var root = path.resolve( __dirname, '../..' );
module.paths = [ path.resolve( root, 'bin/nodejs/node_modules' ) ];
var ini = require( 'ini' );
var config = ini.parse( fs.readFileSync( path.resolve( root, '.install/install.ini' ), 'utf-8' ) )
var arg = process.argv[ 2 ];

console.log( 'Processing config.ini ...' );
var data = fs.readFileSync( path.resolve( root, '.install/conf/config.ini' ), 'utf-8' );
data = data.replace( /%SITE_NAME%/gim, config.Mandatory.SITE_NAME );
data = data.replace( /%TIME_ZONE%/gim, config.Mandatory.TIME_ZONE );
data = data.replace( /%DB_DUMP_TIME%/gim, config.Optional.DB_DUMP_TIME );
data = data.replace( /%DB_HOST%/gim, config.Optional.DB_HOST );
data = data.replace( /%SMTP_SERVER%/gim, config.Optional.SMTP_SERVER );
data = data.replace( /%SMTP_FROM%/gim, config.Optional.SMTP_FROM );
fs.writeFileSync( path.resolve( root, 'www/mars40/config.ini' ), data, 'utf-8' );

var src = ( arg == 'SSL' ? 'httpd-ssl.conf' : 'httpd.conf' );
console.log( 'Processing ' + src + ' ...' );
var data = fs.readFileSync( path.resolve( root, '.install/conf/' + src ), 'utf-8' );
data = data.replace( /%MARS_ROOT%/gim, root.replace( /\\/g, '/' ) );
data = data.replace( /%SERVER_ADMIN%/gim, config.Optional.SERVER_ADMIN );
fs.writeFileSync( path.resolve( root, 'conf/httpd.conf' ), data, 'utf-8' );

console.log( 'Processing my.ini ...' );
var data = fs.readFileSync( path.resolve( root, '.install/conf/my.ini' ), 'utf-8' );
data = data.replace( /%MARS_ROOT%/gim, root.replace( /\\/g, '/' ) );
fs.writeFileSync( path.resolve( root, 'conf/my.ini' ), data, 'utf-8' );

console.log( 'Processing php.ini ...' );
var data = fs.readFileSync( path.resolve( root, '.install/conf/php.ini' ), 'utf-8' );
data = data.replace( /%MARS_ROOT%/gim, root );
fs.writeFileSync( path.resolve( root, 'conf/php.ini' ), data, 'utf-8' );

console.log( 'Processing schtasks.xml ...' );
var data = fs.readFileSync( path.resolve( root, '.install/conf/schtasks.xml' ), 'utf-8' );
data = data.replace( /%AUTHOR%/gim, config.Optional.AUTHOR );
data = data.replace( /%INTERVAL%/gim, config.Optional.INTERVAL );
data = data.replace( /%MARS_ROOT%/gim, root );
fs.writeFileSync( path.resolve( root, '.install/schtasks.xml' ), data, 'utf-8' );
console.log( 'Done.' );
