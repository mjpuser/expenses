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
		initialize: (options) ->
			BaseView::initialize.call this, options
			@expenses = @collection
			@listenTo @expenses, 'sync remove', @graph

		daysBetween: (start, end) ->
			a = start.getTime()
			b = end.getTime()
			return (b - a)/(1000*60*60*24)

		normalize: ->
			data = []
			days = @daysBetween(@expenses.start, @expenses.end)

			xCoords = for day in [1..days]
				d = new Date(@expenses.start.getTime())
				d.setDate(d.getDate() + day)
				d.getTime()

			for model in @expenses.models
				datum = _.find data, (d) ->
					d.key == model.get('category')

				if not datum
					datum =
						key: model.get('category')
						values: {}
					data.push datum

				date = new Date(model.get 'date')
				date.setMinutes(date.getUTCMinutes() + date.getTimezoneOffset())
				date = date.getTime()
				if date not in xCoords
					xCoords.push date

				date = '' + date
				value = datum.values[date] || 0
				datum.values[date] = value + model.get('amount')

			for datum in data
				datum.values = xCoords.map (x) ->
					[ x, datum.values['' + x] || 0 ]

			return data

		graph: ->
			self = this
			if @expenses.models.length
				nv.addGraph ->
					chart = nv.models.multiBarChart()
						.transitionDuration(350)
						.x((d) -> d[0])   		# We can modify the data accessor functions...
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
						.datum(self.normalize())
						.call(chart)

					nv.utils.windowResize(chart.update)

					chart
