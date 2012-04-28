step = require('step')
errors = require('../../errors')
shoes = require('../../data/shoes').shoes

exports.index = (request, response, next) -> 
	step(
		loadData = ->
			shoes.getAll(request.user, @.parallel())

		renderView = (error, shoes) ->
			if error
				return next new errors.DataError('An error occured while loading data for the index page (shoes).', error)

			response.render('shoes/index',
				currentUser: request.user
				shoes: shoes
			)
	)

