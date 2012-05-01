connectionManager = require('./connectionmanager')
errors = require('../errors')
_ = require('underscore')

class Runs
	_database = null

	getById: (id, callback) ->
		_database.get(id, (error, response) ->
			if error
				return callback(error)
			
			run = mapFrom(response)	
			callback(error, run)
		)

	getNumberOfRunsPerYear: (user, callback) ->
		database().view('runs/runCountPerYear', { startkey: [user.id, {}], endkey: [user.id], group: true, descending: true }, 
			(error, response) ->
				if error
					return callback(error)

				runsPerYear = _(response).map((document) ->
					year: document.key[1]
					numberOfRuns: document.value
				)
			
				callback(error, runsPerYear)
			)

	getRunsByYear: (user, year, callback) ->
		startDate = "#{year}-12-31"
		endDate = "#{year}-01-01"

		database().view('runs/runsByYear', { startkey: [user.id, startDate], endkey: [user.id, endDate], descending: true },
			(error, response) ->
				if error
					return callback(error)

				runs = _(response).map((document) -> 
					mapFrom(document.value))

				callback(error, runs)
			)

	getRunsForShoes: (user, shoesId, callback) ->
		database().view('runs/runsForShoes', { key: [user.id, shoesId] },
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

		database().save(id, revision, run, 
			(error, response) ->
				if error
					return callback(error)
				
				callback(error, 
					id: response.id
					revision: response.revision
				)
			)

	database = () ->
		return _database if _database

		connection = connectionManager.getConnection()
		return _database = connection.database('trackmyrun')

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
		user: document.user

	prepareForPersistence = (run) ->
		run['type'] = 'run'
		delete run.id
		delete run.revision

exports.runs = new Runs()