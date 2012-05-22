step = require('step')
errors = require('../../errors')
runs = require('../../data/runs').runs

exports.delete = (request, response, next) ->
	runId = request.params.id

	step(
		loadData = ->
			runs.getById(runId, @)

		removeRun = (error, run) ->
			if error
				return next new errors.DataError('An error occured while loading the data for removing a run from the data store.', error)

			runs.remove(run, @)

		redirectToIndex = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while removing a run from the data store.', error)

			response.redirect('/runs')	
	)