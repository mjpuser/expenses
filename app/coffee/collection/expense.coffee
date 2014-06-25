define [
	'backbone',
	'model/form/expense'
], (
	Backbone,
	ExpenseModel
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

		parse: (data) ->
			data.results.sort (a, b) ->
				comare = 0
				if a.date < b.date
					compare = 1
				else if a.date > b.date
					compare = -1
				compare

			return data.results

	ExpenseCollection
