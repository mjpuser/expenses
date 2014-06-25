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
		options:
			form:
				view: FormView
				model: FormModel
			list:
				view: ExpenseListView
				collection: ExpenseCollection
			template: template


	IndexPage
