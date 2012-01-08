step = require('step')
errors = require('./../../errors')
Runs = require('./../../data/runs')
Shoes = require('./../../data/shoes')

exports.edit = (request, response) ->
	runId = request.params.id
	renderViewForEditRun(runId, response)

exports.update = (request, response) ->
	runId = request.params.id
	
	if not request.form.isValid		
		renderViewForEditRun(runId, response, request.form.getErrors())
		return

	runs = new Runs() 

	step(
		getRun = ->
			runs.getById(runId, @)

		updateRun = (error, run) ->
			if error
				throw new errors.DataError('An error occured while loading the data for updating a run.', error)
			
			applyChangesTo(run, request.form)
			run.speed = calculateSpeedFor(run)

			runs.save(run, @)

		redirectToIndex = (error) ->
			if error
				throw new errors.PersistenceError('An error occured while saving a run in the data store.', error)

			response.redirect('/runs')	
	)

renderViewForEditRun = (runId, response, validationErrors) ->
	step(
		loadData = ->
			# TODO: Retrieve ALL shoes !!!!
			shoes = new Shoes()
			shoes.getShoesInUse(@.parallel())

			if not validationErrors
				runs = new Runs() 
				runs.getById(runId, @.parallel())

		renderView = (error, shoesInUse, run) ->
			if error
				throw new errors.DataError('An error occured while loading data for the edit run page.', error)

			if validationErrors
				run = mapRunFromErroneousInput(response.locals(), runId)

			response.render('runs/edit', 
				run: run
				shoesInUse: shoesInUse or []
				validationErrors: validationErrors or {}
			)
	)

applyChangesTo = (run, formData) ->
	run.date = formData.date
	run.distance = formData.distance
	run.duration = createDurationFrom(formData)
	run.averageHeartRate = formData.averageHeartRate
	run.shoes = formData.shoes
	run.comments = formData.comments
	
#TODO: refactor into seperate module!!
mapRunFromErroneousInput = (formData, runId) ->
	date: formData.date
	distance: formData.distance
	duration: createDurationFrom(formData)
	id: runId
	averageHeartRate : formData.averageHeartRate
	shoes: formData.shoes		
	comments: formData.comments

createDurationFrom = (formData) ->
	hours: 	formData.durationHours
	minutes: formData.durationMinutes
	seconds: formData.durationSeconds

# TODO: refactor into domain object??
calculateSpeedFor = (newRun) -> 
	durationInSeconds = (newRun.duration.hours * 3600) + (newRun.duration.minutes * 60) + newRun.duration.seconds
	speed = (newRun.distance / durationInSeconds) * 3600
	return parseFloat(speed.toFixed(2))