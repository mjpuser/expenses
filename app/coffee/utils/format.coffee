define(->
	format =
		date: (dformat, date) ->
			formatted = date.toISOString()
			if dformat == 'YYYY-MM-DD'
				year = date.getUTCFullYear()
				month = format.number.lead(date.getUTCMonth() + 1)
				day = format.number.lead date.getUTCDate()
				formatted = "#{year}-#{month}-#{day}"
			console.log 'date', date, 'format', formatted
			formatted

		number:
			lead: (x, length) ->
				length ?= 2
				x = '' + x
				while x.length < length
					x = '0' + x
				x

	format
)
