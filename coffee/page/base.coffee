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
				console.log('views', @views)
				views = for name, View of @views
					console.log name, View
					new View
				console.log views
				view.render() for view in views

		render: ->
			@trigger 'render:before'
			this.$el.html @template()
			@trigger 'render:after'
