step = require('step')
errors = require('../../errors')
Runs = require('../../data/runs')

exports.index = (request, response) -> 
	year = determineYearFrom(request)
	
	step(
		loadData = ->
			runs = new Runs()
			runs.getNumberOfRunsPerYear(@.parallel())
			runs.getRunsByYear(year, @.parallel())

		renderView = (error, numberOfRunsPerYear, runs) ->
			if error
				throw new errors.DataError('An error occured while loading data for the index page (runs).', error)

			response.render('runs/index',
				numberOfRunsPerYear: numberOfRunsPerYear
				runs: runs,
				year: year 
			)
	)

determineYearFrom = (request) ->
	year = request.params.year
	if year
		parseInt(year, 0)
	else	
		new Date().getFullYear() 

