console.log( 'script.coffee' )

if window.Storage and window.JSON
	window.storage = (key) ->
		set: (value) ->
			localStorage.setItem(key, JSON.stringify(value))
		get: ->
			item = localStorage.getItem(key)
			JSON.parse(item) if item

if !Date.now
	Date.now = ->
		new Date().getTime()

# Utility Functions

#old
window.getParameterByName = (name) ->
	name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
	regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
	results = regex.exec(location.search)
	if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))

#old
window.setPlayerValue = ( name, value ) ->
	$( 'span.' + name ).text( value )
	$( "input[name='" + name + "']").val( value )

window.calculateAge = ( date, birthday ) ->
	# date and birthday are Date Objects
	ageDifMs = date.getTime() - birthday.getTime()
	ageDate = new Date(ageDifMs)
	Math.abs ageDate.getUTCFullYear() - 1970

# ClubCard Object
window.ClubCard = ( options ) ->
	@opts = options or {}
	return @

if window.location.href isnt "http://localhost/vegas.hyprtxt.com/dev/index.html"
	# console.log( storage( 'Vegas' ).get() )
	if storage( 'Vegas' ).get() is undefined
		window.location.replace 'index.html'
	else
		window.the_player = new Player( storage( 'Vegas' ).get() )


reportHand = ( a_hand ) ->
	# console.log( a_hand )
	if a_hand.type == 'strategy'
		a_hand = a_hand.hand
	a_hand.cards.map ( card, i ) ->
		return card.valueLetter() + card.unicodeSuit()
		# return card.rawValue + card.unicodeSuit()




# JacksOrBetter = new Poker() in _Simple.coffee

playPoker = ( stream ) ->
	credits = 0
	Strategey = new Simple()
	TheDeck = new Deck()
	TheDeck.shuffle()
	TheHand = new Hand(
		deck: TheDeck
		size: 5
	)
	# console.log TheHand
	# console.log reportHand( TheHand )
	$('pre').html( '' )
	$('pre').append( reportHand( TheHand ) + ' ' )
	$('pre').append( JacksOrBetter.score( TheHand, bet ).status + '\n' )
	theGame = Strategey.play( TheHand )
	$('pre').append( theGame.rule + '\n' )
	$('pre').append( reportHand( TheHand ) + ' ' )
	# console.log reportHand( TheHand )

	# Score Poker
	bet = 5
	score = JacksOrBetter.score( theGame, bet )
	credits = credits - bet
	credits = credits + score.win
	# console.log credits
	the_player.set( 'cash', the_player.get('cash') + credits )
	the_player.increment( 'hands' )
	$('pre').append( score.status )
	# console.log( JSON.stringify( score ) + "\n" )

# playPoker()
# module.exports = playPoker

awesome = () ->
	# [1..4].map ( i ) ->
	playPoker()

awesome()

# window.setInterval( awesome, 100 )


