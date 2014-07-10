define [
	'view/form',
	'template/expense/form',
	'utils/date'
], (
	FormView,
	template,
	dateUtil
) ->

	ExpenseFormView = FormView.extend
		el: '.form'
		initialize: (options) ->
			FormView::initialize.call this, options
			@on 'render:after', ->
				# autofill date
				@$el.find('.date input').val(dateUtil.format('YYYY-MM-DD', new Date())).change()

		log: console.log.bind console, '[ExpenseFormView]'
		options:
			template: template
