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
			@horizon = 'month'
			@expenses = @collection

			@on 'render:after', ->
				@$el.find("[data-horizon=\"#{@horizon}\"]").addClass('active')

			@on 'change:range', (start, end) ->
				@expenses.fetchRange(start, end)

		events:
			'click .button[data-horizon]': 'clickHorizon'
			'click .next': 'clickNext'
			'click .prev': 'clickPrev'

		clickHorizon: (e) ->
			@horizon = $(e.target).data('horizon')
			@$el.find('.active').removeClass('active')
			@$el.find('.' + @horizon).addClass('active')
			@computeRange()

		clickNext: (e) ->
			start = new Date(@expenses.start.getTime())
			if @horizon == 'month'
				start.setMonth(start.getMonth() + 1)

			if @horizon == 'week'
				start.setDate(start.getDate() + 7)

			@computeRange(@horizon, start)

		clickPrev: (e) ->
			start = new Date(@expenses.start.getTime())
			if @horizon == 'month'
				start.setMonth(start.getMonth() - 1)

			if @horizon == 'week'
				start.setDate(start.getDate() - 7)

			@computeRange(@horizon, start)


		computeRange: (horizon, start) ->
			horizon ?= @horizon
			start = start || new Date(@expenses.start.getTime())
			if horizon == 'week'
				start.setDate(start.getDate() - start.getDay())
				end = new Date(start.getTime())
				end.setDate(end.getDate() + 6)

			if horizon == 'month'
				start.setDate(1)
				end = new Date(start.getTime())
				end.setMonth(end.getMonth() + 1)
				end.setDate(end.getDate() - 1)

			@trigger 'change:range', start, end

		log: console.log.bind console, '[NavigationView]'

		view: 'month' # can be month|week

		options:
			template: template
