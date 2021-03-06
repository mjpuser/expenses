define [
	'view/base',
	'utils/date',
	'nvd3',
	'd3'
], (
	BaseView,
	dateUtil,
	nv,
	d3
) ->
	GraphViwe = BaseView.extend
		el: '.graph svg'
		initialize: (options) ->
			BaseView::initialize.call this, options
			@expenses = @collection
			@listenTo @expenses, 'sync', @graph

		normalize: ->
			data = []
			days = dateUtil.daysBetween(@expenses.start, @expenses.end)
			xCoords = for day in [1..days]
				d = new Date(@expenses.start.toISOString())
				d.setUTCDate(d.getUTCDate() + day - 1)
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
				date = '' + date.getTime()
				value = datum.values[date] || 0
				datum.values[date] = value + model.get('amount')

			data = [{ key: '', values: {} }] if data.length == 0

			for datum in data
				datum.values = xCoords.map (x) ->
					[ x, datum.values['' + x] || 0 ]

			return data

		graph: ->
			self = this
			nv.addGraph ->
				chart = nv.models.multiBarChart()
					.x((d) -> d[0])   		# We can modify the data accessor functions...
					.y((d) -> d[1])
					.reduceXTicks(true)   #If 'false', every single x-axis tick label will be rendered.
					.rotateLabels(0)      #Angle to rotate x-axis labels.
					.showControls(true)   #Allow user to switch between 'Grouped' and 'Stacked' mode.
					.groupSpacing(0.1)    #Distance between each group of bars.

				if self.expenses.models.length == 0
					chart.forceY([0,50])

				chart.xAxis
					.tickFormat((d) -> (new Date(d)).toUTCString().substr(0,12))

				chart.yAxis
					.tickFormat(d3.format(',.2f'))

				d3.select('.graph svg')
					.datum(self.normalize())
					.call(chart)

				nv.utils.windowResize(chart.update)

				chart
