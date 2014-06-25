define [
	'model/form/validation',
	'backbone',
	'underscore'
], (
	Validation,
	Backbone,
	_
) ->
	BaseModel = Backbone.Model.extend
		save: (attrs, options) ->
			options ?= {}
			options.url = this.url() + '?returnbody=true'
			Backbone.Model::save.call this, attrs, options
		
	BaseModel
