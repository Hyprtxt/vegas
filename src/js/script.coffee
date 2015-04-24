console.log( 'script.coffee', Hand )

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
# $('pre').append( reportHand( TheHand ) + ' ' )
# $('pre').append( JacksOrBetter.score( TheHand, bet ).status + '\n' )
	theGame = Strategey.play( TheHand )
# $('pre').append( theGame.rule + '\n' )
	# console.log( theGame.rule )
# $('pre').append( reportHand( TheHand ) + ' ' )
	# console.log reportHand( TheHand )

	# Score Poker
	bet = 5
	score = JacksOrBetter.score( theGame, bet )
	credits = credits - bet
	credits = credits + score.win
	# console.log credits
	the_player.set( 'cash', the_player.get('cash') + credits )
	the_player.set( 'spend', the_player.get('spend') + bet )
	the_player.increment( 'hands' )
# $('pre').append( score.status )
# $('pre').append( '\n\n' )
	# console.log( JSON.stringify( score ) + "\n" )

# playPoker()
# module.exports = playPoker



# window.setInterval( awesome, 10 )

# # shim layer with setTimeout fallback
# window.requestAnimFrame = do ->
# 	window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or (callback) ->
# 		window.setTimeout callback, 1000 / 60
# 		return
# # usage:
# animloop = ->
# 	window.requestAnimFrame animloop
# 	awesome()
# 	return

# requestAnimationFrame( awesome )

# window.Toggle = ( ) ->
# 	# @opts = options or {}
# 	@status = false
# 	@loop = 0
# 	return @

# Toggle::fn = () ->
# 	[1..20].map ( i ) ->
# 		playPoker()
# 	the_player.save()
# 	return requestAnimationFrame( @fn() )

# Toggle::start = (  ) ->
# 	@status = true
# 	@loop = @fn()
# 	return

# Toggle::stop = ( ) ->
# 	@status = false
# 	window.cancelAnimationFrame( @fn() )
# 	return

# Toggle::toggle = ( ) ->
# 	if @status is false
# 		@start()
# 	else
# 		@stop()

# pokerTime = new Toggle( )



# $('a.toggle').on 'click', ( e ) ->
# 	pokerTime.toggle()

	# console.log toggle, myReq
	# if toggle is false
	# 	myReq = 0
	# 	toggle = true
	# 	myReq = requestAnimationFrame( awesome )
	# else
	# 	cancelAnimationFrame( myReq )
	# 	toggle = false
	# console.log myReq
	# return

# myReq = requestAnimationFrame( awesome )
# cancelAnimationFrame( myReq )
# console.log myReq

# animloop()

toggle = false
$('a.toggle').on 'click', ( e ) ->
	console.log toggle
	if toggle is false
		toggle = true
		# playTen()
	else
		toggle = false
	return

playTen = () ->
	console.log 'something'
	# play 10 hands
	[1..10].map ( i ) ->
		playPoker()
		return
	the_player.save()
	# if toggle
	# 	playTen()


# x = 1
# while x < 20
# 	if x is 5
# 		break
# 	x++
# 	console.log x

# 	[1..20].map ( i ) ->
# 		playPoker()
# 	the_player.save()


