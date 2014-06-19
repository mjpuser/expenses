define [
	'backbone',
	'underscore'
], (
	Backbone,
	_
) ->
	Backbone.View.extend
		el: 'body'

		initialize: (options) ->
			@options = _.extend {}, @options, options
			@model ?= @options.model
			@template = @options.template

			@on 'render', ->
				@trigger 'render:before'
				@render()
				@trigger 'render:after'

			@on 'render:after', ->
				for name, option of @options
					if option.view?
						view = new option.view model: new option.model if option.model?
						view.trigger('render')


		render: ->
			@$el.html @template()
