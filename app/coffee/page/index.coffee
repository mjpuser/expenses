define [
	'view/base',
	'view/expense/form',
	'view/expense/list',
	'view/expense/graph',
	'model/form/expense',
	'collection/expense',
	'template/page/index'
], (
	BaseView,
	FormView,
	ExpenseListView,
	GraphView,
	FormModel,
	ExpenseCollection,
	template
) ->
	IndexPage = BaseView.extend
		initialize: (options) ->
			BaseView::initialize.call this, options
			@on 'render:after', ->
				@stopListening @views.form.model
				@stopListening @views.list.collection
				@listenTo @views.form.model, 'sync', ->
					@views.list.collection.fetchMonth 2014, '06'
				@listenTo @views.list.collection, 'sync remove', ->
					@views.graph.graph @views.list.collection.data()

		options:
			form:
				view: FormView
				model: FormModel
			list:
				view: ExpenseListView
				collection: ExpenseCollection
			graph:
				view: GraphView
			template: template

	IndexPage
