connectionManager = require('./connectionmanager')
errors = require('../errors')
_ = require('underscore')

module.exports = class Runs
	_database = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')

	getById: (id, callback) ->
		_database.get(id, (error, response) ->
			if error
				return callback(error)
			
			run = mapFrom(response)	
			callback(error, run)
		)

	getNumberOfRunsPerYear: (callback) ->
		_database.view('runs/runCountPerYear',  { group: true, descending: true }, 
			(error, response) ->
				if error
					return callback(error)

				runsPerYear = _(response).map((document) ->
						year: document.key
						numberOfRuns: document.value
				)
			
				callback(error, runsPerYear)
			)

	getRunsByYear: (year, callback) ->
		startDate = year + '-12-31'
		endDate = year + '-01-01'

		_database.view('runs/runsByYear', { startkey: startDate, endkey: endDate, descending: true }
			(error, response) ->
				if error
					return callback(error)

				runs = _(response).map((document) -> 
					mapFrom(document.value))

				callback(error, runs)
			)

	save: (run, callback) ->
		id = run.id
		revision = run.revision
		
		prepareForPersistence(run)

		_database.save(id, revision, run, 
			(error, response) -> 
				if error
					return callback(error)
				
				callback(error, 
					id: response.id
					revision: response.revision
				)
			)

	mapFrom = (document) ->
		id: document._id
		revision: document._rev
		averageHeartRate: document.averageHeartRate
		comments: document.comments
		date: document.date
		distance: document.distance
		duration: document.duration
		shoes: document.shoes
		speed: document.speed

	prepareForPersistence = (run) ->
		run['type'] = 'run'
		delete run.id
		delete run.revision