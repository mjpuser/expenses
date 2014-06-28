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
			@listenTo @collection, 'sync remove', ->
				@render()

		log: console.log.bind console, '[ExpenseListView]'

		events:
			'click .delete': 'clickDelete'
			'click .save': 'clickSave'
			'click .attr': 'clickAttr'

		clickAttr: (e) ->
			@$el.find('.attr[contenteditable]').removeAttr('contenteditable')
			$(e.target).attr('contenteditable', '')

		clickDelete: (e) ->
			id = $(e.target).data('id')
			model = @collection.where(id: id)[0]
			model.destroy()
			@collection.remove model

		clickSave: (e) ->
			id = $(e.target).data('id')
			model = @collection.where(id: id)[0]
			attrs = $(e.target).parents('tr').first().find('td.attr')
			for el in attrs.toArray()
				attr = $(el).data('name')
				val = $(el).text()
				if $.isNumeric val
					val = parseInt val

				model.set(attr, val)

			model.save()

		options:
			template: template
