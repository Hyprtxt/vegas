console.log( 'script.coffee' )

# Utility Functions

window.getParameterByName = (name) ->
	name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
	regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
	results = regex.exec(location.search)
	if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))

window.setPlayerValue = ( name, value ) ->
	$( 'span.' + name ).text( value )
	$( "input[name='" + name + "']").val( value )