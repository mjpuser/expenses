requirejs.config {
	baseUrl: 'js/'
	paths:
		backbone: 'lib/backbone'
		underscore: 'lib/underscore'
		jquery: 'lib/jquery'
		nvd3: 'lib/nv.d3'
		d3: 'lib/d3'
		foundation: '//cdnjs.cloudflare.com/ajax/libs/foundation/5.2.2/js/foundation.min'
	shim:
		foundation:
			deps: ['jquery']
		nvd3:
			deps: ['d3']
			exports: 'nv'
		d3:
			exports: 'd3'
	deps: ['app', 'foundation']
	callback: (app) ->
		app.main()
}
