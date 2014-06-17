define [
	'page/base',
	'template/page/index',
	'view/expense/form'
], (
	Page,
	template,
	Form
) ->
	IndexPage = Page.extend
		initialize: (options) ->
			Page::initialize.call this, options
			@template ?= template
			@views =
				form: Form


	IndexPage
