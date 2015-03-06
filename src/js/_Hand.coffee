'use strict'

# Hand Object

window.Hand = ( options ) ->
	@opts = options or {}
	@opts.deck = options.deck
	@opts.size = options.size or 0
	@cards = []
	while @cards.length < @opts.size
		@cards.push( @opts.deck.draw() )
	# console.log( @opts.deck.cards.length )
	return @

Hand::replace = ( index ) ->
	idx = index or 0
	@cards.splice( idx, 1, @opts.deck.draw() )
	return

Hand::keepArray = ( array ) ->
	self = @
	array.map ( i ) ->
		self.replace( i )
	return

Hand::keepOne = ( index ) ->
	idx = index or 0
	[0..4].map( ( v ) ->
		if idx != v
			@replace( idx )
	)
	return

# module.exports = Hand