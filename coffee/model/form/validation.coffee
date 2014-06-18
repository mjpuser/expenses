define [
	'underscore'
], (
	_
) ->
	String::capitalize = ->
		return @charAt(0).toUpperCase() + @substr(1)
	Validation =
		methods:
			number: (val, arg) ->
				if !/^\d+$/.test(val || '')
					'is not a valid number'
			pattern: (val, arg) ->
				if !arg.test((val || '').toString())
					'is not a valid string'
			required: (val, arg) ->
				if /^\s*$/.test(val || '')
					'is required'
		mixin:
			validate: (attrs) ->
				messages = for field, methods of @validation
					fieldMessages = for method, arg of methods
						Validation.methods[method] attrs[field], arg
					fieldMessages = (message for message in fieldMessages when message?)

					if fieldMessages.length > 0
						fieldMessage = {}
						fieldMessage.field = field
						fieldMessage.messages = fieldMessages
						fieldMessage

				messages = (message for message in messages when message)
				_.flatten messages
