_ = require('underscore')

module.exports = class RunFactory
	createDefault: () ->
		type: 'run'
		date: _.getCurrentDate()
		distance: ''
		duration:
			hours: ''
			minutes: ''
			seconds: ''
		averageHeartRate: ''
		shoes: -1
		comments: ''