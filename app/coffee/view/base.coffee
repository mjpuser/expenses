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
			@collection ?= @options.collection
			@template = @options.template

			@on 'render', ->
				@trigger 'render:before'
				@render()
				@trigger 'render:after'

			@on 'render:after', ->
				for name, option of @options
					if option?.view?
						view = new option.view({
							model: new option.model if option.model?
							collection: new option.collection if option.collection?
						})

						view.trigger 'render'

		render: ->
			console.log @collection, @model
			@$el.html @template(
				model: @model
				collection: @collection
				_: _
			)
