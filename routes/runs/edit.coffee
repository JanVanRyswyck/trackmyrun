step = require('step')
errors = require('./../../errors')
Runs = require('./../../data/runs')
Shoes = require('./../../data/shoes')

exports.edit = (request, response) ->
	runId = request.params.id
	renderViewForRun(runId, response)

# exports.update = (request, response) ->

renderViewForRun = (runId, response, validationErrors) ->
	step(
		loadData = -> 
			runs = new Runs()
			runs.getById(runId, @.parallel())

			shoes = new Shoes()
			shoes.getShoesInUse(@.parallel())

		renderView = (error, run, shoesInUse) ->
			if(error)
				throw new errors.DataError('An error occured while loading data for the edit run page.', error)

			response.render('runs/edit', 
				validationErrors: validationErrors or {}
				run: run
				shoesInUse: shoesInUse or []
			)
	)
