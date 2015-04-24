# 'use strict'
console.log 'lobby.coffee'

# setPlayerValue 'name', getParameterByName( 'name' )
# setPlayerValue 'mood', getParameterByName( 'mood' )
# setPlayerValue 'age', getParameterByName( 'age' )
# setPlayerValue 'location', 'The Lobby'
# setPlayerValue 'cash', '600.00'
# setPlayerValue 'inventory', 'roomKeys, playersClubCard'


the_player.update()
console.log the_player.time()
# the_player.useHour()
# the_player.useHour()
# console.log the_player.time()

buffet = 'unset'


$( 'button' ).on 'click', ( e ) ->
	action = $( e.target ).data('action')
	if the_player.opts.hunger is 20 and action isnt 'buffet'
		alert 'Too hungry, must eat'
		return false
	if the_player.opts.stamina is 0 and action isnt 'room'
		alert 'Too tired, must sleep'
		return false

	if action is 'loiter'
		the_player.loiter()
		# the_player.update()
		the_player.save()

	if action is 'buffet'
		if buffet is true
			the_player.stayAtBuffet()
		else
			buffet = true
			the_player.purchaseBuffet()
		the_player.save()
	else
		buffet = false

	if action is 'room'
		the_player.sleep()
		the_player.save()

	if action is 'poker'
		hands = the_player.handsPerHour()
		bet = 1
		# bet = $('#bet').val()
		# if bet > 1000 or bet < 1
		# 	alert( 'bet should be between 1 and 1000')
		# 	return false
		$.getJSON 'http://cards.hyprtxt.com/' + hands + '/' + bet, ( data ) ->
			console.log( data )
			$pre = $('pre')
			$pre.html('')
			data.games.map ( v, i ) ->
				$pre.append( i + ' ' + v.draw + ' -> ' + v.play + ' ' + v.score.status + ' ' + v.score.win + '\n' )
			$pre.append( '\n' )
			$pre.append( 'Hands: ' + data.hands + '\n' )
			$pre.append( 'Spend: ' + data.spend + '\n' )
			$pre.append( 'Payout: ' + data.credits + '\n' )
			sHeight = $pre[0].scrollHeight
			$pre.scrollTop( sHeight )
			the_player.set 'spend', the_player.get('spend') + data.spend
			the_player.set 'hands', the_player.get('hands') + data.hands
			the_player.set 'cash', the_player.get('cash') + data.credits
			# the_player.set 'spend' 
			# the_player.set 'spend' 
		the_player.loiter()
		the_player.update()
		the_player.save()
	console.log buffet