'use strict'

# Simple Stratgey Object

# if typeof module is 'object'
	# Poker = require('./_Poker')
	# # Util need to be created or removed...
	# Util = require( './_Util' )
	# JacksOrBetter = new Poker()

if typeof window is 'object'
	# Util is in Poker
	window.JacksOrBetter = new Poker()

Simple = ( options ) ->
	@opts = options or {}
	return @

Simple::play = ( hand ) ->
	score = JacksOrBetter.score( hand, 5 )

	# Simple Strategy 
	result = {}
	result.type = 'strategy'
	result.hand = hand
	result.rule = 'Hold - default'
	# Four of a kind, straight flush, royal flush
	# ruleFlush = ( ) ->
	if score.status is 'royalflush'
		result.rule = 'Hold - royalflush'
		return result
	if score.status is 'straightflush'
		result.rule = 'Hold - straightflush'
		return result
	if score.status is '4kind'
		result.rule = 'Hold - 4kind'
		return result

	# 4 to a royal flush
	high = JacksOrBetter.getHighCards( hand )
	flush = JacksOrBetter.getFlushCards( hand )
	royalFlush = JacksOrBetter.getRoyalFlushCards( hand, high, flush )
	if flush.cards.length >= 3
		if high.cards.length >= 3
			if royalFlush.cards.length is 4
				hand.cards.map( ( card, i ) ->
					if royalFlush.cards.indexOf( card ) is -1
						hand.replace( i )
				)
				result.hand = hand
				result.rule = '4 to a royal flush'
				return result

	# Three of a kind, straight, flush, full house
	if score.status is '3kind'
		result.hand = Util.holdDupes( hand, 3 )
		result.rule = 'Hold - 3kind'
		return result

	if score.status is 'straight'
		result.rule = 'Hold - straight'
		return result
	if score.status is 'flush'
		result.rule = 'Hold - flush'
		return result
	if score.status is 'fullhouse'
		result.rule = 'Hold - fullhouse'
		return result

	# 4 to a straight flush
	straightFlushReturn = false
	replaceCard = 0
	straight = JacksOrBetter.getStraightOutlierCard( hand, 'all' )
	if flush.cards.length > 3
		if straight.length isnt 0
			# console.log( "FFFFFFFFFF", flush.suit, straight );
			# once = false
			# console.log 'flush straight oulier: ' + straight
			hand.cards.map ( card, i ) ->
				# console.log card.value()
				if card.value() is straight
					if card.suit() isnt flush.suit
						replaceCard = i
						straightFlushReturn = true
				return

	if straightFlushReturn
		hand.replace( replaceCard )
		result.hand = hand
		result.rule = '4 to a straight flush'
		return result

	# Two pair
	if score.status is '2pair'
		hand.cards.map( ( card, i ) ->
			occurance = 0
			hand.cards.map( ( compare_card ) ->
				if card.value() is compare_card.value()
					occurance++
			)
			if occurance is 1
				# console.log( hand.cards, i )
				hand.replace( i )
				# console.log( hand.cards )
		)
		result.hand = hand
		result.rule = 'Hold 2 Pair'
		return result

	# High pair
	if score.status is 'jacksbetter'
		result.hand = Util.holdDupes( hand, 2 )
		result.rule = 'Hold the jacksbetter pair'
		return result

	# 3 to a royal flush
	if royalFlush.cards.length > 2
		hand.cards.map ( card, i ) ->
			if royalFlush.cards.indexOf( card ) is -1
				hand.replace( i )
			return
		result.rule = '3 to a royal flush'
		return result

	# 4 to a flush
	if flush.cards.length > 3
		hand.cards.map ( card, i ) ->
			if flush.cards.indexOf( i ) is -1
				hand.replace( i )
			return
		result.rule = '4 to a flush'
		return result

	# Low pair
	if score.status is 'lowpair'
		result.hand = Util.holdDupes( hand, 2 )
		result.rule = 'Hold the Low Pair'
		return result

	# 4 to an outside straight
	outsideStraight = JacksOrBetter.getStraightOutlierCard( hand, 'outside' )
	if outsideStraight.length isnt 0
		# once = false
		# console.log 'ouside straight oulier: ' + outsideStraight
		hand.cards.map ( card, i ) ->
			if card.value() is outsideStraight
				hand.replace( i )
		result.rule = '4 to an outside straight'
		return result

	# console.log( 'Things', high.cards, flush.cards, flush.suit )

	# Two Suited High Cards
	doReturn = false
	if high.cards.length > 0
		highSuitCount = [0,0,0,0]
		hand.cards.map ( card, i ) ->
			if card.isHigh()
				highSuitCount[card.suit()]++
		# console.log( highSuitCount )
		highSuitCount.map ( v, i ) ->
			if v > 1
				doReturn = true
				hand.cards.map ( card, idx ) ->
					if card.isHigh()
						if card.suit() isnt i
							hand.replace( idx )
					else
						hand.replace( idx )
					# hand.replace( idx )
					return
				# hand.cards.map ( card, idx ) ->
				# 	console.log card.valueLetter() + card.unicodeSuit()
			return
	if doReturn
		# console.log( 'test ' )
		result.rule = 'Hold 2 Suited High Cards'
		return result

	# 2 suited high cards
	# if flush.cards.length > 1
	# 	if high.cards.length > 1
	# 		# console.log( 'Things', high.cards, flush.cards, flush.suit )
	# 		suitedHigh = []
	# 		high.cards.map ( card_idx ) ->
	# 			if hand.cards[card_idx].suit*() is flush.suit
	# 				suitedHigh.push( card_idx )
	# 			return
	# 		if suitedHigh.length > 1
	# 			# console.log( '2+ suited high cards', suitedHigh )
	# 			hand.keepArray( suitedHigh )
	# 			result.rule = '2 suited high cards'
	# 			return result

	# 3 to a straight flush

	# 0,1,2
	# 1,2,3
	# 2,3,4
	# 3,4,5
	# 4,5,6
	# 5,6,7
	# 6,7,8
	# 7,8,9
	# 8,9,10
	# 9,10,11
	# 10,11,12


	# 2 unsuited high cards (if more than 2 then pick the lowest 2)
	# if high.cards.length > 1
	# 	if high.cards.length == 2
	# 		# console.log  " CARDSSSS " + high.cards
	# 		hand.keepArray( high.cards )
	# 		result.rule = '2 unsuited high cards'
	# 		return result
		# else
			# console.log( 'MORE THAN 2 High' )

	# Suited 10/J, 10/Q, or 10/K



	# NN 4 to a straight
	if straight.length isnt 0
		# once = false
		# console.log straight
		hand.cards.map ( card, i ) ->
			if card.value() is straight
				hand.replace( i )
		result.rule = 'NN 4 to a straight'
		result.hand = hand
		return result



	# # NN One high card
	highcard = false

	# console.log( 'high cards ', high.cards.length )
	# isHigh = ( elem, idx, arr ) ->

	if high.cards.length is 1
		hand.cards.map ( card, i ) ->
			if card.isHigh()
				highcard = true
			else
				hand.replace( i )
			return
		result.rule = 'Hold One High Card'
		result.hand = hand
		return result

	# Discard everything
	if highcard is false
		# console.log( 'lose everything' )
		hand.replace(0)
		hand.replace(1)
		hand.replace(2)
		hand.replace(3)
		hand.replace(4)
		result.rule = 'Discard Everything'
		result.hand = hand
	return result

if typeof module is 'object'
	module.exports Simple

if typeof window is 'object'
	window.Simple = Simple
