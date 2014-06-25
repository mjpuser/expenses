define [
	'view/base',
	'model/form/expense',
	'template/expense/show',
	'jquery'
], (
	BaseView,
	ExpenseModel,
	template,
	$
) ->

	ExpenseListView = BaseView.extend
		el: '.list'
		log: console.log.bind console, '[ExpenseListView]'
		initialize: (options) ->
			BaseView::initialize.call this, options
			@listenTo @collection, 'sync', ->
				@render()
			@listenTo @collection, 'remove', ->
				@render()

			@on 'render:before', ->
				@collection.fetchMonth 2014, '06'

		log: console.log.bind console, '[ExpenseListView]'

		events:
			'click .delete': 'clickDelete'

		clickDelete: (e) ->
			id = $(e.target).data('id')
			model = @collection.where(id: id)[0]
			model.destroy()
			@collection.remove model

		options:
			template: template
