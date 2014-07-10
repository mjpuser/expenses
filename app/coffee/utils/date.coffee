define([
	'utils/number'
], (
	numberUtil
)->
	util =
		daysBetween: (start, end) ->
			a = start.getTime()
			b = end.getTime()
			return (b - a)/(1000*60*60*24)

		format: (dformat, date) ->
			formatted = date.toISOString()
			if dformat == 'YYYY-MM-DD'
				year = date.getUTCFullYear()
				month = numberUtil.pad(date.getUTCMonth() + 1)
				day = numberUtil.pad(date.getUTCDate())
				formatted = "#{year}-#{month}-#{day}"
			formatted
)
