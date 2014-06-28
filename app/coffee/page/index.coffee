define [
	'view/base',
	'view/expense/form',
	'view/expense/list',
	'view/expense/graph',
	'view/expense/navigation',
	'model/expense',
	'collection/expense',
	'template/page/index'
], (
	BaseView,
	FormView,
	ExpenseListView,
	GraphView,
	NavigationView,
	ExpenseModel,
	ExpenseCollection,
	template
) ->
	IndexPage = BaseView.extend
		initialize: (options) ->
			BaseView::initialize.call this, options
			@expenses = new ExpenseCollection()
			@expense = new ExpenseModel()

			@options.form.model = @expense
			@options.list.collection = @expenses
			@options.graph.collection = @expenses
			@options.navigation.collection = @expenses

			fetch = ->
				@expenses.fetchRange()

			@listenTo @expense, 'sync', fetch
			@on 'render:after', ->
				fetch.call(this)
				@stopListening @views.list
				@listenTo @views.list, 'delete', fetch

		options:
			form:
				view: FormView
			list:
				view: ExpenseListView
			graph:
				view: GraphView
			navigation:
				view: NavigationView
			template: template

	IndexPage
