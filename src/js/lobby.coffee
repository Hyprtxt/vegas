console.log 'checkin.coffee'

setPlayerValue 'name', getParameterByName( 'name' )
setPlayerValue 'mood', getParameterByName( 'mood' )
setPlayerValue 'age', getParameterByName( 'age' )
setPlayerValue 'location', 'The Lobby'
setPlayerValue 'cash', getParameterByName( 'cash' )
setPlayerValue 'inventory', 'roomKeys, playersClubCard'


# Hotel::thing () ->
# 	@opts
# 	@daily_rate = options.daily_rate or 
# 	@weekly_rate = options.weekly_rate or 

# Player::init () ->