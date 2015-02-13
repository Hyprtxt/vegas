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

NGINX_PATH = process.env.NGINX_PATH || '/etc/nginx';
WEB_PATH = process.env.WEB_PATH || '/var/www';

preWrap = function( thing ) {
	return '<pre>' + thing + '</pre>';
}

module.exports = {
	/* GET home page. */
	// '/' get
	// router.get('/sites', 
	list: function ( req, res ) {
		var pileodata = {};
		glob("*", { cwd: NGINX_PATH +'/sites-available' }, function ( er, sites_available ) {
			glob("*", { cwd: NGINX_PATH +'/sites-enabled' }, function ( er, sites_enabled ) {
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
				res.send( symlink );
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
				res.send( unsymlink );
			});
		}
		else {
			res.send('failure');
		}
	},

	// 
	exec: function ( req, res ) {
		self = this;		console.log( req.param('command'), req.param('site') );
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

