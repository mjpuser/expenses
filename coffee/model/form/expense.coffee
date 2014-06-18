define [
	'model/form/base'
], (
	FormModel
) ->
	ExpenseFormModel = FormModel.extend
		urlRoot: '/db/buckets/expense/keys'
		validate: ->
			v = FormModel::validate.apply(this, [].slice.call(arguments))

		validation:
			amount:
				number: true

			category:
				required: true

			date:
				pattern: /^\d{4}-\d{2}-\d{2}$/
