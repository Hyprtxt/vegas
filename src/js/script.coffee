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

window.getParameterByName = (name) ->
	name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
	regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
	results = regex.exec(location.search)
	if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))

window.setPlayerValue = ( name, value ) ->
	$( 'span.' + name ).text( value )
	$( "input[name='" + name + "']").val( value )

# Local Utility

calculateAge = ( date, birthday ) ->
	# date and birthday are Date Objects
	ageDifMs = date.getTime() - birthday.getTime()
	ageDate = new Date(ageDifMs)
	Math.abs ageDate.getUTCFullYear() - 1970

# ClubCard Object

window.ClubCard = ( options ) ->
	@opts = options or {}
	return @

# Player Object

window.Player = ( options ) ->
	@opts = options or {}
	@opts.name = options.name or ''
	@opts.mood = options.mood or ''

	@opts.cash = options.cash or 0
	@opts.spend = options.spend or 0
	@opts.hands = options.hands or 0

	@opts.speed = options.speed or 1.0
	@opts.hunger = options.hunger or 10
	@opts.stamina = options.stamina or 20
	@opts.location = options.location or ''

	@opts.birthDay = options.birthDay or 21
	@opts.birthYear = options.birthYear or 1987
	@opts.birthMonth = options.birthMonth or 7

	@opts.inventory = options.inventory or []

	@opts.playerRetireDate = options.playerRetireDate or new Date().now()
	@opts.playerDay = options.playerDay or 5
	@opts.playerHour = options.playerHour or 6

	return @

Player::updateDynamic = ( key, val ) ->
	$( '.' + key ).text( val )

Player::updateStatic = ( key ) ->
	$( '.' + key ).text( @opts[key] )
	return true

Player::update = () ->
	@updateStatic( 'name' )
	@updateStatic( 'mood' )
	@updateDynamic( 'age', @age() )
	@updateDynamic( 'date', @date() )
	@updateDynamic( 'time', @time() )
	@updateStatic( 'location' )
	@updateStatic( 'cash' )
	@updateStatic( 'stamina' )
	@updateStatic( 'hunger' )
	@updateStatic( 'spend' )
	@updateStatic( 'hands' )
	@updateStatic( 'speed' )
	@updateDynamic( 'handsPerHour', @handsPerHour() )
	@updateDynamic( 'speedMod', @speedMod() )
	return true

Player::speedMod = () ->
	if @opts.hands > 1000000
		return 2
	else
		return ( Math.round( ( @opts.hands/1000 ) )/1000 ) + 1

Player::handsPerHour = () ->
	return Math.floor( @speedMod() * 720 )

Player::get = ( key ) ->
	return @opts[key]

Player::set = ( key, val ) ->
	@opts[key] = val
	@updateDynamic( key, val )
	return true

Player::save = () ->
	storage( 'Vegas' ).set( @opts )
	return true

# Player::load = () ->
# 	storage( 'Vegas' ).get()

Player::birthDayDate = ( ) ->
	return new Date( @opts.birthYear, @opts.birthMonth, @opts.birthDay )

Player::todayDate = ( ) ->
	days = @opts.playerDay * 86400000
	hours = @opts.playerHour * 3600000
	date = new Date( @opts.playerRetireDate + days + hours )
	return date

Player::age = () ->
	return calculateAge( @todayDate(), @birthDayDate() )

Player::birthDay = ( ) ->
	return @opts.birthYear + ' ' + @opts.birthMonth + ' ' + @opts.birthDay

Player::date = () ->
	d = @todayDate()
	day = d.getDate()
	month = d.getMonth()
	year = d.getFullYear()
	return year + "-" + month + "-" + day

Player::time = () ->
	d = @todayDate()
	hour = d.getHours()
	return hour + '00'

Player::spend = ( n ) ->
	cash = @opts.cash - n
	if cash > 0 
		@opts.cash = cash
		@updateStatic( 'cash' )
		return true
	else
		return false

Player::useFood = () ->
	hunger = @opts.hunger
	if hunger == 18
		@opts.mood = 'starving'
	if hunger == 20
		return false
	@opts.hunger++
	@updateStatic( 'hunger' )
	return true

Player::useStamina = () ->
	stamina = @opts.stamina
	if stamina == 2
		@opts.mood = 'tired'
	if stamina == 0
		return false
	@opts.stamina--
	@updateStatic( 'stamina' )
	return true

Player::useHour = () ->
	hours = @opts.playerHour
	if hours is 23
		@opts.playerHour = 0
		@opts.playerDay++
	else
		@opts.playerHour++
	@updateDynamic( 'date', @date() )
	@updateDynamic( 'time', @time() )
	return true

Player::loiter = () ->
	@useFood()
	@useStamina()
	@useHour()

Player::eat = () ->
	@useHour()
	hunger = @opts.hunger - 10
	if hunger < 0
		@opts.hunger = 0
	else
		@opts.hunger = hunger
	@updateStatic( 'hunger' )
	return true

Player::sleep = () ->
	@useHour()
	@useHour()
	@useHour()
	@useHour()
	@useHour()
	@useHour()
	@useHour()
	@useHour()
	@useFood()
	@useFood()

	@opts.stamina = 20
	@update( 'mood', 'fair' )
	@updateStatic( 'mood' )
	@updateStatic( 'stamina' )
	return true

Player::purchaseBuffet = () ->
	if @spend( 25 )
		@eat()
		@useStamina()
		return true
	else
		return false

Player::stayAtBuffet = () ->
	@eat()
	@useStamina()
	return true


# Card Object

window.Card = ( options ) ->
	@opts = options or {}
	@opts.suit = options.suit or 0
	@opts.value = options.value or 0
	return @

Card::value = () ->
	return @opts.value

Card::suit = () ->
	return @opts.suit

Card::suitName = () ->
	suitNames = [
		'hearts'
		'diamonds'
		'clubs'
		'spades'
	]
	return suitNames[@opts.suit]

Card::unicodeSuit = () ->
	suitUnicodeOutline = [
		'\u2661'
		'\u2662'
		'\u2667'
		'\u2664'
	]
	return suitUnicodeOutline[@opts.suit]

Card::color = () ->
	# console.log( @opts.suit )
	if @suit() == 0 or @suit() == 1
		return 'red'
	else
		return 'black'




if window.location.href isnt "http://localhost/vegas.hyprtxt.com/dev/index.html"
	# console.log( storage( 'Vegas' ).get() )
	if storage( 'Vegas' ).get() is undefined
		window.location.replace 'index.html'
	else
		window.the_player = new Player( storage( 'Vegas' ).get() )