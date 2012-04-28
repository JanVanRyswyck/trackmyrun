step = require('step')
errors = require('../errors')
runs = require('../data/runs').runs
shoes = require('../data/shoes').shoes

exports.index = (request, response, next) -> 
	step(
		loadData = ->
			return @() unless request.user

			runs.getNumberOfRunsPerYear(request.user, @.parallel())
			shoes.getShoesInUse(request.user, @.parallel())

		renderView = (error, numberOfRunsPerYear, shoesInUse) ->
			if error
				return next new errors.DataError('An error occured while loading data for the main index page.', error)

			response.render('index',
				currentUser: request.user
				numberOfRunsPerYear: numberOfRunsPerYear 
				shoesInUse: shoesInUse
			)
	)
