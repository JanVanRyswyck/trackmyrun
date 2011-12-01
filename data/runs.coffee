cradle = require('cradle')
connectionManager = require('./connectionmanager')
_ = require('underscore')

module.exports = class Runs
	_database = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')

	getNumberOfRunsPerYear: (callback) ->
		_database.view('runs/numberPerYear', group: true, (error, response) ->
			if error
				callback(error)

			runsPerYear = _.map(response, 
				(document) ->
					year: document.key
					numberOfRuns: document.value
			)
		
			callback(error, runsPerYear)
		)