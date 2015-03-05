console.log( 'script.coffee' )

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
	return

# Player Object

window.Player = ( options ) ->
	@opts = options or {}
	@opts.name = options.name or ''
	@opts.mood = options.mood or ''
	@opts.stamina = options.stamina or 20
	@opts.hunger = options.hunger or 10
	@opts.location = options.location or ''
	@opts.cash = options.cash or '0.00'
	@opts.inventory = options.inventory or []
	@opts.birthYear = options.birthYear or 1987
	@opts.birthMonth = options.birthMonth or 7
	@opts.birthDay = options.birthDay or 21
	@opts.playerRetireDate = options.playerRetireDate or new Date().now()
	@opts.playerDay = options.playerDay or 5
	@opts.playerHour = options.playerHour or 6
	return @

Player::birthDayDate = ( ) ->
	return new Date( @opts.birthYear, @opts.birthMonth, @opts.birthDay )

Player::todayDate = ( ) ->
	days = @opts.playerDay * 86400000
	hours = @opts.playerHour * 3600000
	console.log( @opts.playerRetireDate + days + hours )
	date = new Date( @opts.playerRetireDate + days + hours )
	return date

Player::age = () ->
	return calculateAge( @todayDate(), @birthDayDate() )

Player::birthDay = ( ) ->
	return @opts.birthYear + ' ' + @opts.birthMonth + ' ' + @opts.birthDay

Player::today = () ->
	d = @todayDate()
	hour = d.getHours()
	day = d.getDate()
	month = d.getMonth()
	year = d.getFullYear()
	return year + "-" + month + "-" + day + ' ' + hour

Player::useCash = ( n ) ->
	cash = @opts.cash - n
	if cash > 0 
		@opts.cash = cash
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
	return true

Player::useStamina = () ->
	stamina = @opts.stamina
	if stamina == 2
		@opts.mood = 'tired'
	if stamina == 0
		return false
	@opts.stamina--
	return true

Player::useHour = () ->
	hours = @opts.playerHour
	if hours is 23
		@opts.playerHour = 0
		@opts.playerDay++
	else
		@opts.playerHour++
	@useFood()
	@useStamina()
	return true

Player::purchaseBuffet = () ->
	if @useCash( 25 )
		@eat()
		@useStamina()
		return true
	else
		return false

Player::purchaseBuffet = () ->

Player::eat = ( ) ->
	hunger = @opts.hunger + 10
	if hunger > 21
		@opts.hunger = 20
	else
		@opts.hunger = hunger
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
