define [
	'app',
	'template/page/index',
], (
	app,
	template
)->
	Page = ->
		console.log('new page')

	Page::render = ->
		app.$(document.body).html(template({graphs: ['1 ', '2 ', '> 3']}))

	new Page
