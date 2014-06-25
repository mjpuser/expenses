define [
	'view/form',
	'template/expense/form'
], (
	FormView,
	template
) ->

	ExpenseFormView = FormView.extend
		el: '.form'
		log: console.log.bind console, '[ExpenseFormView]'
		options:
			template: template
