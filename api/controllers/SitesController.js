/**
 * SitesController
 *
 * @description :: Server-side logic for managing sites
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var _ = require('lodash');
var glob = require('glob');
var child = require('child_process');
var exec = child.exec;
var spawn = child.spawn;
var fs = require('fs');

NGINX_PATH = process.env.NGINX_PATH || '/etc/nginx';
WEB_PATH = process.env.WEB_PATH || '/var/www';

preWrap = function( thing ) {
	return '<pre>' + thing + '</pre>';
}

module.exports = {
	/* GET home page. */
	// '/' get
	// router.get('/sites', 


	// 'get /site/create/:site'
	siteCreate: function ( req, res ) {
		var site = req.param('site');
		var site_path = '/Users/taylor/etc/nginx/sites-available/' + site;
		if ( !fs.existsSync( site_path ) ) {

			var content = "server {\n" + 
			"	root /var/www/" + site + "/public_html;\n" + 
			"	index index.html index.htm;\n" + 
			"	server_name " + site + ";\n" + 
			"	location / {\n" + 
			"		try_files $uri $uri/ /index.html;\n" + 
			"	}\n" + 
			"}\n";

			fs.writeFile( site_path, content, function (err) {
				if (err) throw err;
				console.log('It\'s saved!');
				res.send('Success');
			});

		}
		else {
			res.send('Site Exists');
		}
	},

	// 'get /site/read/:site'
	siteRead: function ( req, res ) {
		fs.readFile('/etc/nginx/sites-available/' + req.param('site'), 'utf8', function ( err, data ) {
			if (err) throw err;
			res.header('Content-Type', 'text/plain');
			res.send( data );
		});
	},


	list: function ( req, res ) {
		var pileodata = {};
		glob("*", { cwd: NGINX_PATH + '/sites-available' }, function ( er, sites_available ) {
			glob("*", { cwd: NGINX_PATH + '/sites-enabled' }, function ( er, sites_enabled ) {
				pileodata.symlinked = [];
				pileodata.notsymlinked = [];
				_.forEach( sites_available, function ( v, i ) {
					if( _.includes( sites_enabled, v ) ) {
						pileodata.symlinked.push( v );
					}
					else {
						pileodata.notsymlinked.push( v );
					}
				});
				pileodata.tomove = [];
				_.forEach( sites_enabled, function ( v, i ) {
					if( !_.includes( sites_available, v ) ) {
						pileodata.tomove.push( v );
					}
				});
				pileodata.available = sites_available;
				pileodata.enabled = sites_enabled;
				// res.render('linker', { title: 'Nginx Sites Config', data: pileodata });
				res.send( pileodata );
			})
		})
	},

	symlinkCreate: function ( req, res ) {
		console.log( req.param('site') );
		if ( req.param('site') != undefined ) {
			var symlink = 'ln -s /etc/nginx/sites-available/' + req.param('site') + ' /etc/nginx/sites-enabled/' + req.param('site');
			exec( symlink, {}, function ( stderr, stdout ) {
				console.log( symlink );
				res.redirect('/panel');
			});
		}
		else {
			res.send('failure');
		}
	},

	symlinkRemove: function ( req, res ) {
		console.log( req.param('site') );
		if ( req.param('site') != undefined ) {
			var unsymlink = 'rm /etc/nginx/sites-enabled/' + req.param('site');
			exec( unsymlink, {}, function ( stderr, stdout ) {
				console.log( unsymlink );
				res.redirect('/panel');
			});
		}
		else {
			res.send('failure');
		}
	},

	// 
	exec: function ( req, res ) {
		console.log( req.param('command'), req.param('site') );
		site = req.param('site') || '';
		switch ( req.param('command') ) {
			case 'ls':
				exec('ls -la', { cwd: '/Users/taylor/www/' + site }, function ( stderr, stdout ) {
					res.send( preWrap( stdout ) );
				});
				break;
			default:
				res.send('Unrecognised Command');
				break;
		}
	},

	ll: function ( req, res ) {
		exec('ls', { cwd: '/Users/taylor/www/' }, function ( stderr, stdout ) {
			console.log( stderr, stdout );
			res.send( preWrap( stdout ) );
		});
	},

	nginxTest: function ( req, res ) {
		response = [];
		test = spawn('nginx', ['-t'], { uid: 0 });

		test.stdout.on('data', function (data) {
			console.log('stdout: ' + data);
			response.push('stdout: ' + data);
		});

		test.stderr.on('data', function (data) {
			console.log('stderr: ' + data);
			response.push('stderr: ' + data);
		});

		test.on('close', function (code) {
			console.log('child process exited with code ' + code);
			response.push('child process exited with code ' + code);
			res.send( preWrap( JSON.stringify( response ) ) );
		});
	},

	nginxReload: function ( req, res ) {
		response = [];
		test = spawn('nginx', ['-s', 'reload'], { uid: 0 });

		test.stdout.on('data', function (data) {
			console.log('stdout: ' + data);
			response.push('stdout: ' + data);
		});

		test.stderr.on('data', function (data) {
			console.log('stderr: ' + data);
			response.push('stderr: ' + data);
		});

		test.on('close', function (code) {
			console.log('child process exited with code ' + code);
			response.push('child process exited with code ' + code);
			res.send( preWrap( JSON.stringify( response ) ) );
		});
	}

};

