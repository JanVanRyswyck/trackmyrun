step = require('step')
_ = require('underscore')
errors = require('../../errors')
options = require('../../data/options')
runs = require('../../data/runs')
shoes = require('../../data/shoes')

exports.update = (request, response, next) ->
	shoesId = request.params.id

	step(
		getRunsForShoes = ->
			shoes.getById(shoesId, @.parallel())			
			runs.getRunsForShoes(request.user, shoesId, @.parallel())
			options.get(request.user, @.parallel())
			
		calculateWear = (error, pairOfShoes, runs, options) ->
			if error
				return next new errors.DataError('An error occured while loading the data for calculating the wear for a pair of shoes.', error)			

			console.log options
			calculateWearFor(pairOfShoes, runs, options.shoes.wearThreshold)
			shoes.save(pairOfShoes, @)

		redirectToIndex = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while saving a pair of shoes in the data store.', error)

			response.redirect('/shoes')	
	)

calculateWearFor = (pairOfShoes, runs, wearThreshold) ->
	pairOfShoes.distance = 0
	pairOfShoes.distance += run.distance for run in runs
	pairOfShoes.status = if pairOfShoes.distance < wearThreshold then "OK" else "Worn"
	pairOfShoes.lastStatusUpdate = _.getCurrentDate()