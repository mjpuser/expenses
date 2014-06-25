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
					chart = nv.models.multiBarChart()
						.transitionDuration(350)
						.x((d) -> d[0])   # We can modify the data accessor functions...
						.y((d) -> d[1])
						.reduceXTicks(true)   #If 'false', every single x-axis tick label will be rendered.
						.rotateLabels(0)      #Angle to rotate x-axis labels.
						.showControls(true)   #Allow user to switch between 'Grouped' and 'Stacked' mode.
						.groupSpacing(0.1)    #Distance between each group of bars.

					chart.xAxis
						.tickFormat((d) -> d3.time.format('%x')(new Date(d)))

					chart.yAxis
						.tickFormat(d3.format(',.2f'))

					d3.select('.graph svg')
						.datum(data)
						.call(chart)

					nv.utils.windowResize(chart.update)

					chart
