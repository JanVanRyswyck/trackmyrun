step = require('step')
errors = require('../../errors')
runs = require('../../data/runs')
shoes = require('../../data/shoes')
Calculator = require('../../services/calculator')

exports.edit = (request, response, next) ->
	renderViewForEditRun(request, response, next)

exports.update = (request, response, next) ->	
	if not request.form.isValid	
		return renderViewForEditRun(request, response, next)

	updateRunFlow(request, response, next)

renderViewForEditRun = (request, response, next) ->
	runId = request.params.id
	validationErrors = request.form.getErrors()	if request.method == 'PUT'

	step(
		loadData = ->
			shoes.getAll(request.user, @.parallel())
			runs.getById(runId, @.parallel()) if not validationErrors

		renderView = (error, allShoes, run) ->
			if error
				return next new errors.DataError('An error occured while loading data for the edit run page.', error)

			if validationErrors
				run = mapRunFrom(response.locals())
				run['id'] = runId

			response.render('runs/edit',
				currentUser: request.user
				pairsOfShoes: allShoes or []
				run: run
				validationErrors: validationErrors or {}
			)
	)

updateRunFlow = (request, response, next) ->
	step(
		getRun = ->
			runs.getById(request.params.id, @)

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