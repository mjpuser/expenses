define [
	'view/base',
	'view/expense/form',
	'view/expense/list',
	'model/form/expense',
	'collection/expense',
	'template/page/index'
], (
	BaseView,
	FormView,
	ExpenseListView,
	FormModel,
	ExpenseCollection,
	template
) ->
	IndexPage = BaseView.extend
		initialize: (options) ->
			BaseView::initialize.call this, options
			@on 'render:after', ->
				@stopListening @views.form.model
				@listenTo @views.form.model, 'error', ->
					@views.list.collection.fetchMonth 2014, '06'
				@listenTo @views.form.model, 'sync', ->
					@views.list.collection.fetchMonth 2014, '06'

		options:
			form:
				view: FormView
				model: FormModel
			list:
				view: ExpenseListView
				collection: ExpenseCollection
			template: template


	IndexPage
