cradle = require('cradle')
connectionManager = require('./connectionmanager')
_ = require('underscore')

module.exports = class Runs
	_database = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')

	getNumberOfRunsPerYear: (callback) ->
		_database.view('runs/runCountPerYear',  { group: true, descending: true }, 
			(error, response) ->
				if error
					return callback(error)

				runsPerYear = _.map(response, 
					(document) ->
						year: document.key
						numberOfRuns: document.value
				)
			
				callback(error, runsPerYear)
			)

	getRunsByYear: (year, callback) ->
		_database.view('runs/runsByYear', { key: year }
			(error, response) ->
				if(error)
					return callback(error)

				runs = _.map(response, 
					(document) ->
						date: document.value.date
						distance: document.value.distance
						duration: document.value.duration
						speed: document.value.speed
						averageHeartRate: document.value.averageHeartRate
						shoes: document.value.shoes
				)

				callback(error, runs)
			)

	add: (newRun) ->
		_database.save(newRun, 
			(error, response) -> 
				console.log(error)
				console.log(response)
			)

	