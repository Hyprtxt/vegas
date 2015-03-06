console.log( 'index.coffee' )

if storage( 'Vegas' ).get() is undefined

	PlayerData = 
		name: ''
		mood: ''
		location: 'Vegas Baby'
		cash: 0
		inventory: []
		birthYear: 1990
		birthMonth: 1
		birthDay: 1
		playerRetireDate: new Date().getTime()
		playerDay: 0
		playerHour: 12

	$('form').on 'submit', ( e ) ->
		# console.log( e )
		if $( 'input#name' ).val() is ''
			alert( 'I\'m sure you have a name' )
			return false
		if $( 'input#location' ).val() is ''
			alert( 'I\'m sure you\'re somewhere' )
			return false

		PlayerData.name = $( 'input#name' ).val()
		PlayerData.location = $( 'input#location' ).val()
		PlayerData.birthYear = $( 'input#birthYear' ).val()
		PlayerData.birthMonth = $( 'input#birthMonth' ).val()
		PlayerData.birthDay = $( 'input#birthDay' ).val()

		player = new Player( PlayerData )
		player.save()

		return

else
	window.location 'lobby.html'
