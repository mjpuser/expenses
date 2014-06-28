define [
	'view/form',
	'template/expense/form',
	'utils/format'
], (
	FormView,
	template,
	format
) ->

	ExpenseFormView = FormView.extend
		el: '.form'
		initialize: (options) ->
			FormView::initialize.call this, options
			@on 'render:after', ->
				# autofill date
				@$el.find('.date input').val(format.date('YYYY-MM-DD', new Date())).change()
				
		log: console.log.bind console, '[ExpenseFormView]'
		options:
			template: template
