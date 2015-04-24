'use strict'

# Card Object

window.Card = ( options ) ->
	@opts = options or {}
	@opts.suit = options.suit or 0
	@opts.value = options.value or 0
	return @

Card::isHigh = () ->
	if @opts.value is 0
		return true
	if @opts.value is 9
		return true
	if @opts.value is 10
		return true
	if @opts.value is 11
		return true
	if @opts.value is 12
		return true
	return false

Card::value = () ->
	return @opts.value

Card::valueLetter = () ->
	valueLetter = [
		'A'
		'2'
		'3'
		'4'
		'5'
		'6'
		'7'
		'8'
		'9'
		'T'
		'J'
		'Q'
		'K'
	]
	return valueLetter[@opts.value]

Card::valueNames = () ->
	valueNames = [
		'ace'
		'two'
		'three'
		'four'
		'five'
		'six'
		'seven'
		'eight'
		'nine'
		'ten'
		'jack'
		'queen'
		'king'
	]
	return valueNames[@opts.value]

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