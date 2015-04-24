module.exports = {
	title: "Retire in Vegas"
	, description: "A Game"
	, javascripts: [
		'bower_components/jquery/dist/jquery.js'
		, 'bower_components/pace/pace.js'
		, 'dev/js/_Card.js'
		, 'dev/js/_Deck.js'
		, 'dev/js/_Hand.js'
		, 'dev/js/_Poker.js'
		, 'dev/js/_Simple.js'
		// , 'dev/js/_Optimal.js'

		, 'dev/js/_Player.js'
		, 'dev/js/script.js'
	]
	, stylesheets: [
		'bower_components/bootstrap/dist/css/bootstrap.css'
		, 'bower_components/pace/themes/green/pace-theme-barber-shop.css'
		, 'dev/css/style.css'
	]
	, bypass: {
		stylesheets: []
		, javascripts: []
	}
};