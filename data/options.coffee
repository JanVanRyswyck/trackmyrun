connectionManager = require('./connectionmanager')

module.exports = class Options
	_database = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')

	get: (callback) ->
		_database.view('options/all', { limit: 1 }, 
			(error, response) ->
				if error
					return process.nextTick(-> callback(error))

				if(0 == response.length)	
					return callback(error, null)

				options = mapFrom(response[0].value)
				process.nextTick(-> callback(error, options))
			)

	save: (options, callback) ->
		id = options.id
		revision = options.revision

		prepareForPersistence(options)

		_database.save(id, revision, options, 
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
		shoes: 
			wearThreshold: document.shoes.wearThreshold

	prepareForPersistence = (options) ->
		options['type'] = 'options'
		delete options.id
		delete options.revision