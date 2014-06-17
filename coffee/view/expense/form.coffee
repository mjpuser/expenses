define [
	'backbone',
	'model/form/base',
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

		render: ->
			@$el.html @template()
			@model.bindForm @$el
