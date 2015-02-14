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

preWrap = function( thing ) {
	return '<pre>' + thing + '</pre>';
}

module.exports = {
	/* GET home page. */
	// '/' get
	// router.get('/sites', 

	// 'get /site/:site'
	renderSite: function ( req, res ) {
		fs.readFile( sails.config.nginx_path + '/sites-available/' + req.param('site'), 'utf8', function ( err, data ) {
			if (err) throw err;
			var data1 = data;
			var data2 = data;
			var data3 = data;
			var view_data = {};
			if ( config = data3.match(/.*/) ) {
				view_data.nginx_config = config.toString();
			}
			if ( port = data1.match(/\:\d\d\d\d/) ) {
				view_data.port = port.toString().replace(':','');
			}
			if ( root = data2.match(/root\ .*\;/) ) {
				view_data.root = root.toString().replace('root ','').replace(';','');
			}
			console.log( view_data );
			res.view('sitePanel', {
				title: 'Site Manager',
				data: view_data
			});
		});
	},

	// 'get /site/create/:site'
	siteCreate: function ( req, res ) {
		var site = req.param('site');
		var site_path = sails.config.nginx_path + '/sites-available/' + site;
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
		fs.readFile( sails.config.nginx_path + '/sites-available/' + req.param('site'), 'utf8', function ( err, data ) {
			if (err) throw err;
			res.header('Content-Type', 'text/plain');
			res.send( data );
		});
	},

	sitePackage: function ( req, res ) {
		fs.readFile( sails.config.nginx_path + '/sites-available/' + req.param('site'), 'utf8', function ( err, data ) {
			if (err) throw err;
			res.header('Content-Type', 'text/plain');
			res.send( data );
		});
	},

	sitePort: function ( req, res ) {
		fs.readFile( sails.config.nginx_path + '/sites-available/' + req.param('site'), 'utf8', function ( err, data ) {
			if (err) throw err;
			res.header('Content-Type', 'text/plain');
			res.send( data.match(/\:\d\d\d\d/).toString().replace(':','') );
		});
	},

	siteRoot: function ( req, res ) {
		fs.readFile( sails.config.nginx_path + '/sites-available/' + req.param('site'), 'utf8', function ( err, data ) {
			if (err) throw err;
			res.header('Content-Type', 'text/plain');
			res.send( data.match(/root\ .*\;/).toString().replace('root ','').replace(';','') );
		});
	},

	symlinkCreate: function ( req, res ) {
		console.log( req.param('site') );
		if ( req.param('site') != undefined ) {
			var symlink = 'ln -s ' + sails.config.nginx_path + '/sites-available/' + req.param('site') + ' ' + sails.config.nginx_path + '/sites-enabled/' + req.param('site');
			exec( symlink, {}, function ( stderr, stdout ) {
				console.log( symlink );
				res.redirect('/');
			});
		}
		else {
			res.send('failure');
		}
	},

	symlinkRemove: function ( req, res ) {
		console.log( req.param('site') );
		if ( req.param('site') != undefined ) {
			var unsymlink = 'rm ' + sails.config.nginx_path + '/sites-enabled/' + req.param('site');
			exec( unsymlink, {}, function ( stderr, stdout ) {
				console.log( unsymlink );
				res.redirect('/');
			});
		}
		else {
			res.send('failure');
		}
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

