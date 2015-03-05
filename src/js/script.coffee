blocks = []
report = {}
report.blocks_list = []
report.blocks = []

getBlocks = ( callback ) ->
	$.ajax(
		url: 'http://api.yothrow.com/block'
		data: { secret: 'secret' }
	)
		.done( callback )

addBlockButtons = ( data ) ->
	blocks = data
	$( data ).each( ( i, v ) ->
		# console.log v
		$( '#blocks' ).append( '<li><button class="add-block" id="' + v.id + '">' + v.name + '</button></li>' )
	)

getQuery = ( id, callback ) ->
	$.ajax(
		url: 'http://yothrow.com/api/result/' + id
		data: { 'testing' : 'supersecret' }
	)
		.done( callback )

renderBlock = ( block ) ->
	# console.log 'renderBlock'
	# console.log report.length
	# console.log block
	block.number = report.blocks_list.length
	tmpl.renderTemplate( block, 'block', [], ( template ) ->
		$('#output').append( template )
		if block.chart
			selector = '#chart' + block.number
			chart[ block.chart_type ]( selector, block.data )
	)

addBlock = ( e ) ->
	# console.log _.findWhere( blocks, { 'id': parseInt( $( e.target ).attr( 'id' ) ) })
	block = _.findWhere( blocks, { 'id': parseInt( $( e.target ).attr( 'id' ) ) })
	# check for exsiting block id?
	report.blocks_list.push block.id
	# console.log report
	getQuery( block.query, ( data ) ->
		block.data = data
		report.blocks.push( block );
		renderBlock( block )
	)

saveReport = ( e ) ->
	console.log e, report
	report.name = $('#name').val()
	$.ajax({
		type: 'POST'
		url: 'http://api.yothrow.com/report/create/'
		data: report
		dataType: 'json'
		success: ( res ) -> 
			console.log res
			alert res
	})
	false

getBlocks( addBlockButtons )

$('body').on( 'click', '.add-block', addBlock )

$('body').on( 'click', '.save-report', saveReport )