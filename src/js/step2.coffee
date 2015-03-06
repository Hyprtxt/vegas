console.log 'step2.coffee'

console.log the_player

the_player.update()

$( '.moodSelect' ).on 'click', ( e ) ->
	mood = $( e.target ).data('mood')
	if mood is 'perfect'
		$( '.response' ).text( 'Perfect, lets go...' )
	else
		$( '.response' ).text( 'Um, we both know thats not true...' )
	the_player.set( 'mood', mood )
	$( '.moodSelect' ).hide()
	$( '.hidden.one' ).removeClass( 'hidden' )


$( '.getCash' ).on 'click', ( e ) ->
	the_player.set( 'cash', 1000 )
	$( '.getCash' ).hide()
	$( '.hidden.two' ).removeClass( 'hidden' )

$( '.buyTicket' ).on 'click', ( e ) ->
	the_player.set( 'cash', 850 )
	the_player.set( 'inventory', ['1 Ticket to Ride'] )
	$( '.buyTicket' ).hide()
	$( '.hidden.three' ).removeClass( 'hidden' )

$( '.fly' ).on 'click', ( e ) ->
	the_player.save()
	return
