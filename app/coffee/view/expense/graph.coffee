define [
	'view/base',
	'nvd3',
	'd3'
], (
	BaseView,
	nv,
	d3
) ->
	GraphViwe = BaseView.extend
		el: '.graph svg'
		graph: (data) ->
			if data.length
				nv.addGraph ->
					chart = nv.models.stackedAreaChart()
						.margin({right: 100})
						.x((d) -> d[0])   # We can modify the data accessor functions...
						.y((d) -> d[1])   # ...in case your data is formatted differently.
						.useInteractiveGuideline(true)    # Tooltips which show all data points. Very nice!
						.rightAlignYAxis(true)      # Let's move the y-axis to the right side.
						.transitionDuration(500)
						.showControls(true)       # Allow user to choose 'Stacked', 'Stream', 'Expanded' mode.
						.clipEdge(true)

					# Format x-axis labels with custom function.
					chart.xAxis
						.tickFormat((d) -> d3.time.format('%x')(new Date(d)))

					chart.yAxis
						.tickFormat(d3.format(',.2f'))

					d3.select('.graph svg')
						.datum(data)
						.call(chart)

					nv.utils.windowResize(chart.update)

					chart
