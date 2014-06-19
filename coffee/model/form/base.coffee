define [
	'model/form/validation',
	'backbone'
], (
	Validation,
	Backbone
) ->
	FormModel = Backbone.Model.extend(Validation.mixin)

	FormModel
