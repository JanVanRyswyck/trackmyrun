step = require('step')
errors = require('../../errors')
FormDataToRunMapper = require('../../mappers/runmapper')
Runs = require('../../data/runs')
Shoes = require('../../data/shoes')
Calculator = require('../../services/calculator')

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
			run.speed = new Calculator().calculateSpeedFor(run)

			runs.save(run, @)

		redirectToIndex = (error) ->
			if error
				throw new errors.PersistenceError('An error occured while saving a run in the data store.', error)

			response.redirect('/runs')	
	)

renderViewForEditRun = (runId, response, validationErrors) ->
	step(
		loadData = ->
			shoes = new Shoes()
			shoes.getShoesInUse(@.parallel())

			if not validationErrors
				runs = new Runs() 
				runs.getById(runId, @.parallel())

		renderView = (error, shoesInUse, run) ->
			if error
				throw new errors.DataError('An error occured while loading data for the edit run page.', error)

			if validationErrors
				run = new FormDataToRunMapper().mapFrom(response.locals())
				run['id'] = runId

			response.render('runs/edit', 
				run: run
				shoesInUse: shoesInUse or []
				validationErrors: validationErrors or {}
			)
	)

applyChangesTo = (run, formData) ->
	run.date = formData.date
	run.distance = formData.distance
	run.duration = new FormDataToRunMapper().mapDurationFrom(formData)
	run.averageHeartRate = formData.averageHeartRate
	run.shoes = formData.shoes
	run.comments = formData.comments