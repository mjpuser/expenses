define [
	'model/form/base'
], (
	FormModel
) ->
	ExpenseModel = FormModel.extend
		urlRoot: '/db/buckets/expense/keys'

		fields:
			amount:
				number: true

			category:
				required: true

			date:
				date: true

	ExpenseModel
