console.log 'step2.coffee'

setPlayerValue( 'name', getParameterByName( 'name' ) )
setPlayerValue( 'age', getParameterByName( 'age' ) )
setPlayerValue( 'location', getParameterByName( 'location' ) )

$( '.moodSelect' ).on 'click', ( e ) ->
	mood = $( e.target ).data('mood')
	if mood is 'perfect'
		$( '.response' ).text( 'Perfect, lets go...' )
	else
		$( '.response' ).text( 'Um, we both know thats not true...' )
	setPlayerValue( 'mood', mood )
	$( '.moodSelect' ).hide()
	$( '.hidden.one' ).removeClass( 'hidden' )


$( '.getCash' ).on 'click', ( e ) ->
	setPlayerValue( 'cash', '1000.00' )
	$( '.getCash' ).hide()
	$( '.hidden.two' ).removeClass( 'hidden' )

$( '.buyTicket' ).on 'click', ( e ) ->
	setPlayerValue( 'cash', '850.00' )
	setPlayerValue( 'inventory', '1 Ticket to Ride' )
	$( '.buyTicket' ).hide()
	$( '.hidden.three' ).removeClass( 'hidden' )

$( '.fly' ).on 'click', ( e ) ->
