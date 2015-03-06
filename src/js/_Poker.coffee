'use strict'

# Util = require( './util' )

window.Util = {}

window.Util.sortNumber = ( a, b ) ->
	return a - b

window.Util.holdDupes = ( hand, length ) ->
	[0..12].map( ( v, i ) ->
		count = 0
		holds = []
		hand.cards.map( ( card, idx ) ->
			if card.opts.value == v
				holds.push( idx )
			return
		)
		if holds.length is length
			hand.cards.map( ( card, index ) ->
				if card.opts.value isnt v
					hand.replace( index )
			)
	)
	return hand

# Poker = require( './Poker' )

# 30, 32, 33, 34
# holdSingle = ( hand, high, hold ) ->
# 	high.cards.map( ( card, i ) ->
# 		letter = hand.cards[i].valueLetter()
# 		if letter is hold
# 			hand.keepOne( card )
# 	)
# 	return


window.Poker = ( options ) ->
	@opts = options or {}
	return @

Poker::score = ( hand, bet ) ->
	self = @
	bet = bet || 5

	if hand.type == 'strategy'
		hand = hand.hand

	# console.log(  hand )
	# , hand.cards  )
	# Doubles
	# rawsuit
	values = []
	hand.cards.map( ( card, i ) ->
		values.push( card.opts.value )
	)

	values.sort( Util.sortNumber )

	suits = []
	hand.cards.map( ( card, i ) ->
		suits.push( card.opts.suit )
	)

	# console.log suits, suits.sort( sortNumber )

	score = 
		status: 'ulose'
		win: 0

	straights = [
		[1..5]
		[2..6]
		[3..7]
		[4..8]
		[5..9]
		[6..10]
		[7..11]
		[8..12]
	]
	royal_straight = [0,9,10,11,12]
	royal = false
	straight = false
	flush = false
	pair1 = false
	pair2 = false
	triple = false
	quad = false
	jacksorbetter = false

	# console.log( values )

	# royal straigt checker
	if JSON.stringify( values ) is JSON.stringify( royal_straight )
		royal = true

	# straight checker
	straights.map( ( v, i ) ->
		if JSON.stringify( values ) is JSON.stringify( v )
			straight = true
			return
	)

	# dupe checker, pair, 2pair, 3kind, 4kind, fullhouse
	[0..12].map( ( v, i ) ->
		# console.log( v )
		count = 0
		values.map( ( val, idx ) ->
			if val == v
				count++
			return
		)
		if count is 2
			if v >= 9 or v is 0
				jacksorbetter = true
			if pair1 is true
				pair2 = true
			else
				pair1 = true
		if count is 3
			triple = true
		if count is 4
			quad = true
		return
	)

	# flush checker
	[0..3].map ( v, i ) ->
		count = 0
		suits.map( ( val, idx ) ->
			if val == v
				count++
			return
		)
		if count is 5
			flush = true
		return

	# Score Reporter
	if royal and flush
		score.status = 'royalflush'
		score.win = bet * 800
		return score
	else if straight and flush
		score.status = 'straightflush'
		score.win = bet * 50
		return score
	else if quad
		score.status = '4kind'
		score.win = bet * 25
		return score
	else if triple and pair1
		score.status = 'fullhouse'
		score.win = bet * 9
		return score
	else if flush
		score.status = 'flush'
		score.win = bet * 6
		return score
	else if straight or royal
		score.status = 'straight'
		score.win = bet * 4
		return score
	else if triple
		score.status = '3kind'
		score.win = bet * 3
		return score
	else if pair1 and pair2
		score.status = '2pair'
		score.win = bet * 2
		return score
	else if jacksorbetter
		score.status = 'jacksbetter'
		score.win = bet * 1
		return score
	else if pair1
		score.status = 'lowpair'
		score.win = 0
		return score
	return score


Poker::paytable = ( ) ->
	payout =
		'royalflush': 800
		'straightflush': 50
		'4kind': 25
		'fullhouse': 9
		'flush': 6
		'straight': 4
		'3kind': 3
		'2pair': 2
		'jacksbetter': 1
		'lowpair': 0
	return payout

Poker::getRoyalFlushCards = ( hand, high, flush ) ->
	royalFlush = 
		cards: []
		suit: flush.suit
	high.cards.map ( cardindex ) ->
		if flush.cards.indexOf( cardindex ) isnt -1
			royalFlush.cards.push( cardindex )
		return
	return royalFlush

Poker::getFlushCards = ( hand ) ->
	flush =
		cards: []
		suit: ''
	[0..3].map ( v, i ) ->
		count = 0
		cards = []
		hand.cards.map ( card, idx ) ->
			if card.opts.suit == v
				count++
				cards.push( idx )
			return
		if cards.length > 2
			flush.cards = cards
			flush.suit = v
			return
	# console.log flush
	return flush

Poker::getHighCards = ( hand ) ->
	high =
		cards: []
	highCards = [0,9,10,11,12]
	hand.cards.map ( card, i ) ->
		highCards.map ( val ) ->
			if card.opts.value is val
				high.cards.push( i )
			return
		return
	return high


allStraights = [
	[0,9,10,11,12]
	[1..5]
	[2..6]
	[3..7]
	[4..8]
	[5..9]
	[6..10]
	[7..11]
	[8..12]
]

outsideStraights = [
	[1,2,3,4]
	[2,3,4,5]
	[3,4,5,6]
	[4,5,6,7]
	[5,6,7,8]
	[6,7,8,9]
	[7,8,9,10]
	[8,9,10,11]
]

Poker::getStraightOutlierCard = ( hand, straight_kind ) ->
	straights = []
	discard = []
	current_hand = []
	good = []
	hands = []

	if straight_kind is 'outside'
		straights = outsideStraights
		good = straights
	else
		straights = allStraights
		good = mapAllStraights( straights )

	current_hand = hand.cards.map ( card, i ) ->
		return card.opts.value
	current_hand.sort( Util.sortNumber )
	# console.log current_hand

	hands = handsWithFourCards( current_hand )
	# console.log hands, good
	hands.map ( hand, i ) ->
		# console.log( hand, i, current_hand[i] )
		good.map ( straight, idx ) ->
			if JSON.stringify( hand ) is JSON.stringify( straight )
				# console.log( 'GREAT SUCCESSS', current_hand[i] )
				discard = current_hand[i]
			return
	return discard

handsWithFourCards = ( current_hand ) ->
	hands = []
	hands.push( current_hand.slice( 1, 5 ) )
	hands.push( spliceOutIdx1( current_hand ) )
	hands.push( spliceOutIdx2( current_hand ) )
	hands.push( spliceOutIdx3( current_hand ) )
	hands.push( current_hand.slice( 0, 4 ) )
	return hands

mapAllStraights = ( straights ) ->
	good = []
	straights.map ( straight ) ->
		good.push straight.slice( 1, 5 )
		return
	straights.map ( straight ) ->
		good.push spliceOutIdx1( straight )
		return
	straights.map ( straight ) ->
		good.push spliceOutIdx2( straight )
		return
	straights.map ( straight ) ->
		good.push spliceOutIdx3( straight )
		return
	straights.map ( straight ) ->
		good.push straight.slice( 0, 4 )
		return
	return good

spliceOutIdx1 = ( thing ) ->
	copy = thing.slice( 0, 1 )
	copy2 = thing.slice( 2, 5 )
	return copy.concat( copy2 )

spliceOutIdx2 = ( thing ) ->
	copy = thing.slice( 0, 2 )
	copy2 = thing.slice( 3, 5 )
	return copy.concat( copy2 )

spliceOutIdx3 = ( thing ) ->
	copy = thing.slice( 0, 3 )
	copy2 = thing.slice( 4, 5 )
	return copy.concat( copy2 )

# sortNumber = ( a, b ) ->
# 	return a - b

# module.exports = Poker
