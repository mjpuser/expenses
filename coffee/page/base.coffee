define [
	'backbone'
], (
	Backbone
) ->
	Backbone.View.extend
		el: 'body'

		initialize: (options) ->
			options ?= {}
			@template = options.template
			@on 'render:after', ->
				for name, View of @views
					view = new View
					view.render()

		render: ->
			@trigger 'render:before'
			this.$el.html @template()
			@trigger 'render:after'
