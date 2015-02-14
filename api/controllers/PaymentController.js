/**
 * SitesController
 *
 * @description :: Server-side logic for managing sites
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

// var _ = require('lodash');
// var glob = require('glob');
// var child = require('child_process');
// var exec = child.exec;
// var spawn = child.spawn;
var fs = require('fs');
var braintree = require('braintree');
var config = sails.config.braintree;
config.environment = braintree.Environment.Sandbox;
var gateway = braintree.connect( config );


module.exports = {

	showCheckout: function ( req, res ) {
		gateway.clientToken.generate({
			// customerId: aCustomerId
		}, function (err, response) {
			var clientToken = response.clientToken
			res.view( 'payment', {
				title: 'Checkout Page',
				clientToken: clientToken
			});
		});
	},

	chargeFive: function ( req, res ) {
		gateway.transaction.sale({
			amount: '5.00',
			creditCard: {
				number: '5105105105105100',
				expirationDate: '05/12'
			}
		}, function (err, result) {
			if (err) throw err;
			if (result.success) {
				console.log('Transaction ID: ' + result.transaction.id);
				res.send('Transaction ID: ' + result.transaction.id);
			} else {
				console.log(result.message);
				res.send(result.message);
			}
		});
	}

};

