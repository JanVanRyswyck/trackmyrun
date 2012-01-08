module.exports = class FormDataToRunMapper
	mapFrom: (formData) ->
		type: 'run'
		date: formData.date
		distance: formData.distance
		duration: @.mapDurationFrom(formData)
		averageHeartRate: formData.averageHeartRate
		shoes: formData.shoes		
		comments: formData.comments

	mapDurationFrom: (formData) ->
		hours: 	formData.durationHours
		minutes: formData.durationMinutes
		seconds: formData.durationSeconds