step = require('step')
errors = require('./../../errors')
Runs = require('./../../data/runs')
Shoes = require('./../../data/shoes')

exports.new = (request, response) ->
	renderViewForNewRun(response, {})

renderViewForNewRun = (response, validationErrors) ->
	step(
		loadData = -> 
			shoes = new Shoes()
			shoes.getShoesInUse(@)

		renderView = (error, shoesInUse) ->
			if(error)
				throw new errors.DataError('An error occured while loading data for the main index page.', error)

			response.render('runs/new', 
				validationErrors: validationErrors or {}
				shoesInUse: shoesInUse or []
			)
	)

exports.create = (request, response) ->
	if not request.form.isValid		
		renderViewForNewRun(response, request.form.getErrors())
		return

	newRun =
		type: 'run'
		date: request.form.date
		distance: request.form.distance
		duration: createDurationFrom(request.form)
		averageHeartRate: request.form.averageHeartRate
		shoes: request.form.shoes
		comments: request.form.comments

	newRun.speed = calculateSpeedFor(newRun)
	
	runs = new Runs()	
	runs.add(newRun)

createDurationFrom = (requestForm) ->
	hours: 	requestForm.durationHours
	minutes: requestForm.durationMinutes
	seconds: requestForm.durationSeconds

calculateSpeedFor = (newRun) -> 
	durationInSeconds = (newRun.duration.hours * 3600) + (newRun.duration.minutes * 60) + newRun.duration.seconds
	speed = (newRun.distance / durationInSeconds) * 3600
	return parseFloat(speed.toFixed(2))
