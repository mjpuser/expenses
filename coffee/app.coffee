define [
	'router',
	'backbone',
	'loadsh'
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
				success: (page) ->
					app.currentPage = page
					page.render()

				error: (err) ->
					console.error(err)
					if path in err.requireModules
						app.loadPage(404)

			app.currentPath = path
			require([ path ], load.success, load.error)

		main: ->
			this.router.on 'route:change', (path) ->
				app.loadPage(path)

			Backbone.history.start()

		router: router

	_.extend(app, Backbone.Events)

	return app
