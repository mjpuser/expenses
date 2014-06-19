define [
	'model/form/base',
	'view/base'
], (
	FormModel
	BaseView,
) ->
	FormView = BaseView.extend
		el: 'form'
		initialize: (options) ->
			BaseView::initialize.call this, options
			@on 'render:after', @bindFormToModel
			@on 'render:after', ->
				@stopListening @model

				@listenTo @model, 'invalid', (model, messages) ->
					for message in messages
						@$el
							.find "label.#{message.field}"
							.addClass "error"
							.find ".error-message"
							.text message.messages

				@listenTo @model, 'change', (model) ->
					for field, _ of model.changed
						@$el
							.find ".field-label.#{field}"
							.removeClass "error"
							.find ".error-message"
							.text ""


		log: console.log.bind console, '[FormView]'

		events:
			'change select': 'changeSelect'
			'click input[type="radio"]': 'clickRadio'
			'click input[type="checkbox"]': 'clickCheckbox'
			'keyup input:not(input[type="radio"], input[type="checkbox"])': 'changeInput'
			'change input:not(input[type="radio"], input[type="checkbox"])': 'changeInput'
			'submit': 'submit'

		submit: (e) ->
			e.preventDefault()
			@model.save()

		bindFormToModel: ->
			form = @$el
			@listenTo @model, 'change', (model, options) ->
				_.each _.keys(model.changed), (attr) ->
					value = model.changed[attr]
					inputs = form.find "[name=\"#{attr}\"]"

					inputs
						.filter '[type="radio"], [type="checkbox"]'
						.filter "[value=\"#{value}\"]"
						.prop 'checked', true

					inputs
						.filter 'input:not([type="radio"], [type="checkbox"]), select'
						.val value

		changeSelect: (e) ->
			input = @$ e.target
			@model.set input.attr('name'), input.val()

		clickRadio: (e) ->
			input = @$ e.target
			@model.set input.attr('name'), input.val()

		clickCheckbox: (e) ->
			input = @$ e.target
			values = (@$(input).val() for input in @$el.find('input[type="checkbox"][name="' + input.attr('name') + '"]:checked').toArray())
			@model.set input.attr('name'), values

		changeInput: (e) ->
			input = @$ e.target
			@model.set input.attr('name'), input.val()

	FormView
