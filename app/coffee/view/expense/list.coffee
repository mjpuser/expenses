define [
	'view/base',
	'template/expense/show'
], (
	BaseView,
	template
) ->

	ExpenseListView = BaseView.extend
		el: '.list'
		log: console.log.bind console, '[ExpenseListView]'
		initialize: (options) ->
			BaseView::initialize.call this, options
			@listenTo @collection, 'sync', ->
				@render()

			@on 'render:before', ->
				@collection.fetchMonth 2014, '06'

		log: console.log.bind console, '[ExpenseListView]'
		options:
			template: template
