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
				date = new Date()
				console.log('date', date)
				start = new Date(date.getFullYear(), date.getMonth())
				console.log('start', start)
				end = new Date(start.getTime())
				end.setMonth(end.getMonth() + 1)
				console.log('start', start, 'end', end)
				@expenses.fetchRange(start, end)

			@listenTo @expense, 'sync', fetch
			@on 'render:after', fetch

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
