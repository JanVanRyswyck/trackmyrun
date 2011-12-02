step = require('step')
errors = require('./../../errors')
Runs = require('./../../data/runs')

exports.index = (request, response, next) -> 
	#TODO: Move to params handler
	yearParam = request.params.year
	year = parseInt(yearParam, 0) if yearParam
	year = new Date().getFullYear() unless year

	step(
		loadData = ->
			runs = new Runs()
			runs.getNumberOfRunsPerYear(@.parallel())
			runs.getRunsByYear(year, @.parallel())

		renderView = (error, numberOfRunsPerYear, runs) ->
			if(error)
				throw new errors.DataError('An error occured while loading data for the index page (runs).', error)

			response.render('runs/index',
				numberOfRunsPerYear: numberOfRunsPerYear
				runs: runs,
				year: year 
			)
	)