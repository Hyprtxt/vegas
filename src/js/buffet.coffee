'use strict'
console.log 'checkin.coffee'

setPlayerValue 'name', getParameterByName( 'name' )
setPlayerValue 'mood', getParameterByName( 'mood' )
setPlayerValue 'age', getParameterByName( 'age' )
setPlayerValue 'location', 'The Lobby'
setPlayerValue 'cash', '600.00'
setPlayerValue 'inventory', 'roomKeys, playersClubCard'

card1 = new Card(
	suit: 0
	value: 0
)
card2 = new Card(
	suit: 1
	value: 0
)

window.player = new Player(
	name: 'Taylor'
	mood: 'fair'
	location: 'Vegas Baby'
	cash: '0.00'
	inventory: ['spareChange']
	birthYear: 1987
	birthMonth: 7
	birthDay: 21
	playerRetireDate: new Date().getTime()
	playerDay: 100
	playerHour: 6
)

# console.log player.birthDay()
# console.log player.age()
console.log player.today()
player.useHour()
player.useHour()
console.log player.today()

console.log card1.unicodeSuit(), card2.unicodeSuit(), card1.color()
