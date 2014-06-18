define [
	'backbone',
	'model/form/expense',
	'template/expense/form'
], (
	Backbone,
	FormModel,
	template
) ->

	FormView = Backbone.View.extend
		el: '.form'

		initialize: (options) ->
			@template = template
			@model ?= new FormModel

		events:
			'submit': 'submit'

		submit: (e) ->
			e.preventDefault()
			@model.save()

		render: ->
			@$el.html @template()
			@model.bindForm @$el
