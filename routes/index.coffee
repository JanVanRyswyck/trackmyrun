step = require('step')
errors = require('./../errors')
Runs = require('./../data/runs')
Shoes = require('./../data/shoes')

exports.index = (request, response)-> 
	step(
		loadData = ->
			runs = new Runs()
			runs.getNumberOfRunsPerYear(@.parallel())

			shoes = new Shoes()
			shoes.getShoesInUse(@.parallel())

		renderView = (error, numberOfRunsPerYear, shoesInUse) ->
			if(error)
				throw new errors.DataError('An error occured while loading data for the main index page.', error)

			response.render('index',
				numberOfRunsPerYear: numberOfRunsPerYear 
				shoesInUse: shoesInUse
			)
	)