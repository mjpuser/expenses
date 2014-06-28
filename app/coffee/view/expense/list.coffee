define [
	'view/base',
	'model/expense',
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
				@collection.fetchMonth()

		log: console.log.bind console, '[ExpenseListView]'

		events:
			'click .delete': 'clickDelete'
			'click .save': 'clickSave'

		clickDelete: (e) ->
			id = $(e.target).data('id')
			model = @collection.where(id: id)[0]
			model.destroy()
			@collection.remove model

		clickSave: (e) ->
			id = $(e.target).data('id')
			model = @collection.where(id: id)[0]
			for el in $(e.target).parents('tr').first().find('td.attr').toArray()
				attr = $(el).data('name')
				val = $(el).text()
				model.set(attr, val)

			model.save()

		options:
			template: template
