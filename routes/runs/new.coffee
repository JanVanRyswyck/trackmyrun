step = require('step')
errors = require('./../../errors')
_ = require('underscore')
Runs = require('./../../data/runs')
Shoes = require('./../../data/shoes')

exports.new = (request, response) ->
	renderViewForNewRun(response)

exports.create = (request, response) ->
	if not request.form.isValid		
		renderViewForNewRun(response, request.form.getErrors())
		return

	step(
		createRun = () ->
			newRun = mapRunFromInput(request.form)
			newRun.speed = calculateSpeedFor(newRun)
			
			runs = new Runs()	
			runs.save(newRun, @)

		redirectToIndex = (error) ->
			if error
				throw new errors.PersistenceError('An error occured while creating a new run in the data store.', error)

			response.redirect('/runs')	
	)

renderViewForNewRun = (response, validationErrors) ->
	step(
		loadData = -> 
			shoes = new Shoes()
			shoes.getShoesInUse(@)

		renderView = (error, shoesInUse) ->
			if error 
				throw new errors.DataError('An error occured while loading data for the new run page.', error)

			run = createDefaultRun()
			if validationErrors
				run = mapRunFromInput(response.locals())
						
			response.render('runs/new',
				run: run
				shoesInUse: shoesInUse or []
				validationErrors: validationErrors or {}
			)
	)

# TODO: Create factory
createDefaultRun = () ->
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

mapRunFromInput = (formData) ->
	type: 'run'
	date: formData.date
	distance: formData.distance
	duration: createDurationFrom(formData)
	averageHeartRate : formData.averageHeartRate
	shoes: formData.shoes		
	comments: formData.comments

createDurationFrom = (formData) ->
	hours: 	formData.durationHours
	minutes: formData.durationMinutes
	seconds: formData.durationSeconds

calculateSpeedFor = (newRun) -> 
	durationInSeconds = (newRun.duration.hours * 3600) + (newRun.duration.minutes * 60) + newRun.duration.seconds
	speed = (newRun.distance / durationInSeconds) * 3600
	return parseFloat(speed.toFixed(2))
