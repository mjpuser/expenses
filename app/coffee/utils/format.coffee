define(->
	format =
		date: (dformat, date) ->
			formatted = date.toDateString()
			if dformat == 'YYYY-MM-DD'
				year = date.getFullYear()
				month = format.number.lead(date.getMonth() + 1)
				day = format.number.lead date.getDate()
				formatted = "#{year}-#{month}-#{day}"
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
