step = require('step')
errors = require('../../errors')
Runs = require('../../data/runs')
Shoes = require('../../data/shoes')

exports.index = (request, response) -> 
	year = determineYearFrom(request)
	
	step(
		loadData = ->
			runs = new Runs()
			runs.getNumberOfRunsPerYear(@.parallel())
			runs.getRunsByYear(year, @.parallel())

			shoes = new Shoes()
			shoes.getAll(@.parallel())

		renderView = (error, numberOfRunsPerYear, runs, shoes) ->
			if error
				throw new errors.DataError('An error occured while loading data for the index page (runs).', error)

			response.render('runs/index',
				numberOfRunsPerYear: numberOfRunsPerYear
				runs: runs,
				shoes: shoes,
				year: year 
			)
	)

determineYearFrom = (request) ->
	year = request.params.year
	if year
		parseInt(year, 0)
	else	
		new Date().getFullYear() 

