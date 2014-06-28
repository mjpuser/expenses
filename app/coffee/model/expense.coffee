define [
	'model/form/base'
], (
	FormModel
) ->
	ExpenseModel = FormModel.extend
		urlRoot: '/db/buckets/expense/keys'
		initialize: (attrs, options) ->
			FormModel::initialize.call(this, attrs, options)
			console.log('initializing expense model')

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
