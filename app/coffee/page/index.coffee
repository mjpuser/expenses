define [
	'view/base',
	'template/page/index',
	'view/expense/form',
	'model/form/expense'
], (
	BaseView,
	template,
	FormView,
	FormModel
) ->
	IndexPage = BaseView.extend
		options:
			form:
				view: FormView
				model: FormModel
			template: template


	IndexPage
