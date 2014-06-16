requirejs.config {
	baseUrl: 'js/'
	paths:
		backbone: 'lib/backbone'
		underscore: 'lib/underscore'
		jquery: 'lib/jquery'
		fastclick: '//cdnjs.cloudflare.com/ajax/libs/fastclick/1.0.0/fastclick.min'
		foundation: '//cdnjs.cloudflare.com/ajax/libs/foundation/5.2.2/js/foundation.min'
	shim:
		foundation:
			deps: ['fastclick']
		fastclick:
			deps: ['jquery']
	deps: ['app', 'foundation']
	callback: (app) ->
		app.main()
}
