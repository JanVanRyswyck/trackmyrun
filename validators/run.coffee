form = require('express-form')

exports.validate = form(
	form.filter('date').trim()
	form.validate('date')
		.regex(/^(19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$/, 
			   'Please specify a valid date (e.g. 2012-01-15).')

	form.filter('distance').toFloat()
	form.validate('distance').isNumeric('Please specify a valid distance.')

	form.filter('durationHours').toInt()
	form.filter('durationMinutes').toInt()
	form.filter('durationSeconds').toInt()

	customValidation = form.validate('duration')
		.custom((value, source)-> 
			validate = (durationFieldValue, maxValue) ->
				throw new Error('Please specify a valid duration.') unless durationFieldValue
				
				value = parseInt(durationFieldValue)	
				throw new Error('Please specify a valid values for the duration.') unless value and 0 < value < maxValue
			
			validate(source.durationHours, 24)
			validate(source.durationMinutes, 60)
			validate(source.durationSeconds, 60)
		)

	form.filter('averageHeartRate').ifNull(0).toInt()
	form.validate('shoes').notRegex(/-1/, 'Please select a pair of shoes.')
	form.filter('comments').ifNull('')
)