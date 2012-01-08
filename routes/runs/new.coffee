step = require('step')
errors = require('../../errors')
RunFactory = require('../../factories/runfactory')
FormDataToRunMapper = require('../../mappers/runmapper')
Runs = require('../../data/runs')
Shoes = require('../../data/shoes')
Calculator = require('../../services/calculator')

exports.new = (request, response) ->
	renderViewForNewRun(response)

exports.create = (request, response) ->
	if not request.form.isValid		
		renderViewForNewRun(response, request.form.getErrors())
		return

	step(
		createRun = () ->
			newRun = new FormDataToRunMapper().mapFrom(request.form)
			newRun.speed = new Calculator().calculateSpeedFor(newRun)
			
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

			run = new RunFactory().createDefault()
			if validationErrors
				run = new FormDataToRunMapper().mapFrom(response.locals())
						
			response.render('runs/new',
				run: run
				shoesInUse: shoesInUse or []
				validationErrors: validationErrors or {}
			)
	)
