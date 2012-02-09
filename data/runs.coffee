cradle = require('cradle')
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
				return process.nextTick(-> callback(error))	
			
			run = mapFrom(response)	
			process.nextTick(-> callback(error, run))
		)

	getNumberOfRunsPerYear: (callback) ->
		_database.view('runs/runCountPerYear',  { group: true, descending: true }, 
			(error, response) ->
				if error
					return process.nextTick(-> callback(error))

				runsPerYear = _(response).map((document) ->
						year: document.key
						numberOfRuns: document.value
				)
			
				process.nextTick(-> callback(error, runsPerYear))
			)

	getRunsByYear: (year, callback) ->
		startDate = year + '-12-31'
		endDate = year + '-01-01'

		_database.view('runs/runsByYear', { startkey: startDate, endkey: endDate, descending: true }
			(error, response) ->
				if error
					return process.nextTick(-> callback(error))

				runs = _(response).map((document) -> 
					mapFrom(document.value))

				process.nextTick(-> callback(error, runs))
			)

	save: (run, callback) ->
		run['type'] = 'run'
		
		_database.save(run.id, run.revision, run, 
			(error, response) -> 
				if error
					process.nextTick(-> callback(error))
				
				process.nextTick(-> callback(error, 
					id: response.id
					revision: response.revision
				))
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