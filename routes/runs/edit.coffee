step = require('step')
errors = require('../../errors')
Runs = require('../../data/runs')
Shoes = require('../../data/shoes')
Calculator = require('../../services/calculator')

exports.edit = (request, response, next) ->
	runId = request.params.id
	renderViewForEditRun(runId, response, next)

exports.update = (request, response, next) ->
	runId = request.params.id
	
	if not request.form.isValid		
		return renderViewForEditRun(runId, response, next, request.form.getErrors())

	runs = new Runs() 
	step(
		getRun = ->
			runs.getById(runId, @)

		updateRun = (error, run) ->
			if error
				return next new errors.DataError('An error occured while loading the data for updating a run.', error)
			
			applyChangesTo(run, request.form)
			run.speed = new Calculator().calculateSpeedFor(run)

			runs.save(run, @)

		redirectToIndex = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while saving a run in the data store.', error)

			response.redirect('/runs')	
	)

renderViewForEditRun = (runId, response, next, validationErrors) ->
	step(
		loadData = ->
			shoes = new Shoes()
			shoes.getAll(@.parallel())

			if not validationErrors
				runs = new Runs() 
				runs.getById(runId, @.parallel())

		renderView = (error, allShoes, run) ->
			if error
				return next new errors.DataError('An error occured while loading data for the edit run page.', error)

			if validationErrors
				run = mapRunFrom(response.locals())
				run['id'] = runId

			response.render('runs/edit', 
				run: run
				pairsOfShoes: allShoes or []
				validationErrors: validationErrors or {}
			)
	)

applyChangesTo = (run, formData) ->
	run.date = formData.date
	run.distance = formData.distance
	run.duration = mapDurationFrom(formData)
	run.averageHeartRate = formData.averageHeartRate
	run.shoes = formData.shoes
	run.comments = formData.comments

mapRunFrom = (formData) ->
	date: formData.date
	distance: formData.distance
	duration: mapDurationFrom(formData)
	averageHeartRate: formData.averageHeartRate
	shoes: formData.shoes		
	comments: formData.comments

mapDurationFrom = (formData) ->
	hours: 	formData.durationHours
	minutes: formData.durationMinutes
	seconds: formData.durationSeconds