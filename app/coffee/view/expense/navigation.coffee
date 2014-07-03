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
				start.setUTCMonth(start.getUTCMonth() + 1)

			if @horizon == 'week'
				start.setUTCDate(start.getUTCDate() + 7)

			@computeRange(@horizon, start)

		clickPrev: (e) ->
			start = new Date(@expenses.start.getTime())
			if @horizon == 'month'
				start.setUTCMonth(start.getUTCMonth() - 1)

			if @horizon == 'week'
				start.setUTCDate(start.getUTCDate() - 7)

			@computeRange(@horizon, start)


		computeRange: (horizon, start) ->
			horizon ?= @horizon
			start = start || new Date(@expenses.start.getTime())
			if horizon == 'week'
				start.setUTCDate(start.getUTCDate() - start.getUTCDay())
				end = new Date(start.getTime())
				end.setUTCDate(end.getUTCDate() + 7)

			if horizon == 'month'
				start.setUTCDate(1)
				end = new Date(start.getTime())
				end.setUTCMonth(end.getUTCMonth() + 1)
				end.setUTCDate(end.getUTCDate() - 1)

			@trigger 'change:range', start, end

		log: console.log.bind console, '[NavigationView]'

		view: 'month' # can be month|week

		options:
			template: template
