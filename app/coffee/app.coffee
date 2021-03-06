define [
	'router',
	'backbone',
	'underscore'
], (
	router,
	Backbone,
	_
) ->
	app =
		currentPath: null

		loadPath: (path) ->
			path = path || 'index'
			path = 'page/' + path

			load =
				success: (Page) ->
					app.currentPage = new Page
					app.currentPage.trigger('render')

				error: (err) ->
					console.log(err.message)
					console.log(err.stack)
					if path in err.requireModules
						app.loadPage(404)

			app.currentPath = path
			require([ path ], load.success, load.error)

		main: ->
			router.on 'route:change', (path) ->
				app.loadPath(path)

			Backbone.history.start()

		router: router
		$: Backbone.$
		Backbone: Backbone
		_: _

	_.extend(app, Backbone.Events)

	return app
