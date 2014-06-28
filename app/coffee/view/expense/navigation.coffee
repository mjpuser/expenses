define [
	'view/base',
	'template/expense/navigation'
], (
	BaseView,
	template
) ->

	NavigationView = BaseView.extend
		el: '.navigation'
		initialize: (options) ->
			BaseView::initialize.call this, options
			@on 'render:after', ->
			@on 'view:set', (view) ->
				@view = view
				@$el.find('.active').removeClass('active')
				@$el.find('.' + view).addClass('active')

		log: console.log.bind console, '[NavigationView]'

		view: 'month' # can be month|week

		options:
			template: template
