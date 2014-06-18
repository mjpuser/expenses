define [
	'model/form/validation',
	'backbone',
	'underscore'
], (
	Validation,
	Backbone,
	_
) ->
	BaseFormModel = Backbone.Model.extend
		initialize: ->
			@on 'error', (m, r, q) ->
				location = r.getResponseHeader 'Location'
				@set 'id', /keys.(\w+$)/.exec(location)[1]

			@on 'invalid', (m, messages) ->
				for message in messages
					@log message.field, message.messages

		log: console.log.bind console, '[FormModel]'
		bindForm: (form) ->
			@_bindFormInputs(form)
			@_bindFormSelects(form)
			@_bindFormRadioButtons(form)
			@_bindFormCheckboxes(form)
			@_bindFormToModel(form)

		_bindFormToModel: (form) ->
			@on 'change', (model, options) ->
				_.each _.keys(model.changed), (attr) ->
					value = model.changed[attr]
					inputs = form.find('[name="' + attr + '"]')

					inputs.filter('[type="radio"], [type="checkbox"]').filter('[value="' + value + '"]').prop('checked', true)

					inputs.filter('input:not([type="radio"], [type="checkbox"]), select').val(value)

		_bindFormSelects: (form) ->
			self = this

			form.delegate 'select', 'change', ->
				input = $(this)
				self.set(input.attr('name'), input.val())

		_bindFormRadioButtons: (form) ->
			self = this

			form.delegate 'input[type="radio"]', 'click', ->
				input = $(this)
				self.set(input.attr('name'), input.val())

		_bindFormCheckboxes: (form) ->
			self = this

			form.delegate 'input[type="checkbox"]', 'click', ->
				input = $(this)
				values = _.map form.find('input[type="checkbox"][name="' + input.attr('name') + '"]:checked').toArray(), ->
					$(input).val()

				self.set(input.attr('name'), values)

		_bindFormInputs: (form) ->
			self = this

			form.delegate 'input:not(input[type="radio"], input[type="checkbox"])', 'change keyup', ->
				input = $(this)
				self.set(input.attr('name'), input.val())

	_.extend BaseFormModel.prototype, Validation.mixin

	BaseFormModel
