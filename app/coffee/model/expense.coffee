define [
	'model/form/base'
], (
	FormModel
) ->
	ExpenseModel = FormModel.extend
		urlRoot: '/db/types/map/buckets/expense/keys'

		fields:
			amount:
				number: true

			category:
				required: true

			date:
				date: true

			name:
				required: true

	ExpenseModel
