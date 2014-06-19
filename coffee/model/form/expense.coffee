define [
	'model/form/base'
], (
	FormModel
) ->
	ExpenseModel = FormModel.extend
		urlRoot: '/db/buckets/expense/keys'
			
		validation:
			amount:
				number: true

			category:
				required: true

			date:
				pattern: /^\d{4}-\d{2}-\d{2}$/

	ExpenseModel
