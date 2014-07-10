define [
	'backbone',
	'model/expense',
	'utils/date',
	'underscore'
], (
	Backbone,
	ExpenseModel,
	dateUtil,
	_
) ->
	ExpenseCollection = Backbone.Collection.extend
		model: ExpenseModel
		initialize: (options) ->
			date = new Date()
			@start = new Date()
			@start.setUTCFullYear(date.getFullYear())
			@start.setUTCMonth(date.getMonth())
			@start.setUTCDate(1)
			@start.setUTCHours(0)
			@start.setUTCMinutes(0)
			@start.setUTCSeconds(0)
			@start.setUTCMilliseconds(0)
			@end = new Date(@start.getTime())
			@end.setUTCMonth(date.getMonth() + 1)

		fetchRange: (start, end) ->
			start ?= @start
			end ?= @end

			from = dateUtil.format('YYYY-MM-DD', start)
			to = dateUtil.format('YYYY-MM-DD', end)

			@start = start
			@end = end

			this.fetch
				url: '/api/expense/search?'
				data:
					q: "date:[#{from} TO #{to}]"
					rows: 10000

		data: ->
			data = []
			xCoords = []
			for model in @models
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

		average: ->

			max = null
			min = null
			@models.forEach (model) ->
				date = new Date(model.get 'date')
				if !max || max < date
					max = date
				if !min || min > date
					min = date

			days = dateUtil.daysBetween(min, max) + 1
			Math.floor(@total() / days)

		total: ->
			total = @models.reduce((sum, model) ->
				sum + parseInt(model.get('amount'))
			, 0)

			total

		parse: (data) ->
			data.results.sort (a, b) ->
				comare = 0
				if a.date < b.date
					compare = 1
				else if a.date > b.date
					compare = -1
				compare

			data.results

	ExpenseCollection
