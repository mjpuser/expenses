define [
	'backbone'
], (
	Backbone
) ->
	Router = Backbone.Router.extend
		routes:
			'*path': 'change'

		log: console.log.bind(console, '[Router]')

		change: (path) ->
			this.log(path)

	return new Router
