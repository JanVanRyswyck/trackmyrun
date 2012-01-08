cradle = require('cradle')
connectionManager = require('./connectionmanager')
errors = require('./../errors')
RunMapper = require('./runmapper')
_ = require('underscore')

module.exports = class Runs
	_database = null
	_runMapper = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')
		_runMapper = new RunMapper()

	getById: (id, callback) ->
		_database.get(id, (error, response) ->
			if(error)
				return callback(error)	
			
			run = _runMapper.mapFrom(response)	
			callback(error, run)
		)

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
					(document) -> _runMapper.mapFrom(document.value)	
				)

				callback(error, runs)
			)

	save: (run, callback) ->
		_database.save(run.id, run.revision, run, 
			(error, response) -> 
				if(error)
					callback(error)
				
				callback(error, 
					id: response.id
					revision: response.revision
				)
			)