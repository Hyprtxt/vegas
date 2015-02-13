/**
 * SitesController
 *
 * @description :: Server-side logic for managing sites
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var _ = require('lodash');
var glob = require('glob');
var exec = require('child_process').exec;

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
			var symlink = 'ln -s /etc/nginx/sites_available/' + req.param('site') + ' /etc/nginx/sites_enabled/' + req.param('site');
			exec( symlink, function ( stderr, stdout ) {
				res.send( preWrap( stdout ) );
			});
		}
		else {
			res.send('failure');
		}
	},

	symlinkRemove: function ( req, res ) {
		console.log( req.param('site') );
		if ( req.param('site') != undefined ) {
			var unsymlink = 'rm /etc/nginx/sites_enabled/' + req.param('site');
			exec( unsymlink, function ( stderr, stdout ) {
				res.send( preWrap( stdout ) );
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
		exec('nginx -t', function ( stderr, stdout ) {
			console.log( stderr, stdout );
			res.send( preWrap( stdout ) );
		});
	},

	nginxReload: function ( req, res ) {
		exec('nginx -s reload', function ( stderr, stdout ) {
			console.log( stderr, stdout );
			res.send( preWrap( stdout ) );
		});
	}

};

