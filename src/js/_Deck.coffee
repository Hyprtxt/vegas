'use strict'

# Card = require( './Card' )

window.Deck = ( options ) ->
	@opts = options or {}
	@suits = [0..3]
	@values = [0..12]
	@cards = @init()
	@shuffled = false
	return @

Deck::init = ( ) ->
	self = @
	deck = self.suits.map( ( suit, i ) ->
		return self.values.map( ( value, val_i ) -> 
			return new Card(
				suit: suit
				value: value
			)
		)
	)
	.reduce( ( a, b ) ->
		return a.concat( b )
	)
	return deck

Deck::shuffle = ( ) ->
	array = @cards
	counter = array.length
	temp = undefined
	index = undefined
	while counter > 0
		index = Math.random() * counter-- | 0
		temp = array[counter]
		array[counter] = array[index]
		array[index] = temp
	@shuffled = true
	return array

Deck::draw = ( ) ->
	return @cards.shift()

# module.exports = Deck