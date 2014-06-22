define [
	'view/form',
	'model/form/expense',
	'template/expense/form'
], (
	FormView,
	FormModel,
	template
) ->

	ExpenseFormView = FormView.extend
		el: '.form'
		log: console.log.bind console, '[ExpenseFormView]'
		options:
			template: template
