indexRoute = require('./routes/index').index
indexRunsRoute = require('./routes/runs/index').index
newRunRoute = require('./routes/runs/new').new
createNewRunRoute = require('./routes/runs/new').create
form = require('express-form')

exports.bootstrapFor = (application) ->
	application.get('/', indexRoute)
	application.get('/runs/new', newRunRoute)
	application.post('/runs', validation, createNewRunRoute)
	application.get('/runs/:year?', indexRunsRoute)

validation = form(
	form.validate('date')
		.regex(/^(0[1-9]|[12][0-9]|3[01])[- //.](0[1-9]|1[012])[- //.](19|20)\d\d$/, 
			   'Please specify a valid date (e.g. 15/01/2012).')

	form.validate('distance').isNumeric('Please specify a valid distance.')

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

	form.validate('shoes').notRegex(/-1/, 'Please select a pair of shoes.')

	form.filter('date').trim()
	form.filter('distance').toFloat()
	form.filter('durationHours').toInt()
	form.filter('durationMinutes').toInt()
	form.filter('durationSeconds').toInt()
	form.filter('averageHeartRate').ifNull(0).toInt()
 	form.filter('comments').ifNull('')
)