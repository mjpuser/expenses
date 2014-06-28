define [
	'view/base',
	'view/expense/form',
	'view/expense/list',
	'view/expense/graph',
	'model/expense',
	'collection/expense',
	'template/page/index'
], (
	BaseView,
	FormView,
	ExpenseListView,
	GraphView,
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

			@listenTo @expense, 'sync', ->
				date = new Date(@expense.get 'date')
				@expenses.fetchMonth date.getFullYear(), date.getMonth() + 1


		options:
			form:
				view: FormView
			list:
				view: ExpenseListView
			graph:
				view: GraphView
			template: template

	IndexPage
