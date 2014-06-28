define [
	'backbone',
	'model/expense',
	'utils/format',
	'underscore'
], (
	Backbone,
	ExpenseModel,
	format,
	_
) ->
	ExpenseCollection = Backbone.Collection.extend
		model: ExpenseModel
		initialize: (options) ->
			date = new Date()
			@start = new Date(date.getFullYear(), date.getMonth())
			@end = new Date(@start.getTime())
			@end.setMonth(@end.getMonth() + 1)

		fetchRange: (start, end) ->
			start ?= @start
			end ?= @end

			from = format.date('YYYY-MM-DD', start)
			to = format.date('YYYY-MM-DD', end)

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
