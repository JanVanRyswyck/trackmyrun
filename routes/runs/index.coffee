step = require('step')
errors = require('../../errors')
runs = require('../../data/runs')
shoes = require('../../data/shoes')

exports.index = (request, response, next) -> 
	year = determineYearFrom(request)
	
	step(
		loadData = ->
			runs.getNumberOfRunsPerYear(request.user, @.parallel())
			runs.getRunsByYear(request.user, year, @.parallel())
			shoes.getAll(request.user, @.parallel())

		renderView = (error, numberOfRunsPerYear, runs, shoes) ->
			if error
				return next new errors.DataError('An error occured while loading data for the index page (runs).', error)

			response.render('runs/index',
				currentUser: request.user
				numberOfRunsPerYear: numberOfRunsPerYear
				runs: runs
				shoes: shoes
				year: year 
			)
	)

determineYearFrom = (request) ->
	year = request.params.year
	if year
		parseInt(year, 0)
	else	
		new Date().getFullYear() 

