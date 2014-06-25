define [
	'model/base',
	'model/form/validation'
], (
	BaseModel,
	Validation
) ->

	FormModel = BaseModel.extend Validation.mixin

	FormModel
