console.log( 'index.coffee' )
$('form').on 'submit', ( e ) ->
	# console.log( e )
	if $( 'input#age' ).val() < 21
		alert( 'You need to be 21 to retire in Vegas' )
		return false
	if $( 'input#name' ).val() is ''
		alert( 'I\'m sure you have a name' )
		return false
	if $( 'input#name' ).val() is ''
		alert( 'I\'m sure you\'re somewhere' )
		return false