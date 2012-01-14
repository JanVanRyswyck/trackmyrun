step = require('step')
errors = require('../../errors')
Shoes = require('../../data/shoes')

exports.index = (request, response) -> 
	step(
		loadData = ->
			shoes = new Shoes()
			shoes.getAll(@.parallel())

		renderView = (error, shoes) ->
			if error
				throw new errors.DataError('An error occured while loading data for the index page (shoes).', error)

			response.render('shoes/index',
				shoes: shoes
			)
	)

