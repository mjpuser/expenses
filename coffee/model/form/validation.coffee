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
				@pattern val, /^\d+$/
			pattern: (val, arg) ->
				arg.test (val || '').toString()
			required: (val, arg) ->
				@pattern val, /^\s*[^\s]+\s*$/

		messages:
			required: (field) -> "#{field} is required"
			number: (field) -> "#{field} must be a number"
			pattern: (field) -> "#{field} must be a valid format"
			date: (field) -> "#{field} must be a date YYYY-MM-DD"
			
		mixin:
			validate: (attrs) ->
				messages = for field, methods of @validation
					fieldMessages = for method, arg of methods
						if !Validation.methods[method] attrs[field], arg
							Validation.messages[method] field.capitalize()
					fieldMessages = (message for message in fieldMessages when message)

					if fieldMessages.length > 0
						fieldMessage = {}
						fieldMessage.field = field
						fieldMessage.messages = fieldMessages
						fieldMessage

				messages = (message for message in messages when message)
				_.flatten messages
