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
			return data.results

	ExpenseCollection
