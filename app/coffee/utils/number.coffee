define(->
	number =
		pad: (x, length) ->
			length ?= 2
			x = '' + x
			while x.length < length
				x = '0' + x
			x
)
