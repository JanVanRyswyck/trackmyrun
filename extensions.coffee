_ = require('underscore')

_.mixin(
	padLeft: (text, totalLength, paddingChar) ->
		string = text.toString()
		while (string.length < totalLength)
	        string = paddingChar + string
	    return string

	getCurrentDate: () ->
		currentDate = new Date()
		return currentDate.getFullYear() + 
			   '-' + _(currentDate.getMonth() + 1).padLeft(2, '0') + 
			   '-' + _(currentDate.getDate()).padLeft(2, '0')
)