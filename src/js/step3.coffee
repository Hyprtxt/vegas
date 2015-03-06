console.log 'checkin.coffee'

the_player.set( 'location', 'Las Vegas, NV' )
the_player.update()

$( 'button' ).on 'click', () ->
	the_player.spend( 250 )
	the_player.updateStatic( 'cash' )
	the_player.save()
	return