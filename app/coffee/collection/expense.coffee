define [
	'backbone',
	'model/form/expense',
	'underscore'
], (
	Backbone,
	ExpenseModel,
	_
) ->
	ExpenseCollection = Backbone.Collection.extend
		model: ExpenseModel

		# year: 4 digit year
		# month: integer; 1 <= month <= 12
		fetchMonth: (year, month) ->
			this.fetch(
				url: '/api/expense/search?'
				data:
					q: "date:#{year}-#{month}*"
					rows: 10000
			)

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
