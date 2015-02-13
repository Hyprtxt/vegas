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

module.exports = {
	/* GET home page. */
	// '/' get
	// router.get('/sites', 
	getSites: function ( req, res ) {
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
				res.render('linker', { title: 'Nginx Sites Config', data: pileodata });
			})
		})
	}

	// get '/exec/:command'
	execCommand: function ( req, res ) {
		switch ( req.param.command ) {
			case 'll':
				exec('ls -la', { cwd: WEB_PATH + '/' }, function ( stderr, stdout ) {
					res.send( stdout );
				});
				break;
			default
				res.send('Unrecognised Command');
				break;
		}
	});
};

