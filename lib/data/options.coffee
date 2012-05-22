connectionManager = require('./connectionmanager')

class Options
	_database = null

	get: (user, callback) ->
		database().view('options/all', { startkey: [user.id], limit: 1 }, 
			(error, response) ->
				if error
					return callback(error)

				if(0 is response.length)	
					return callback(error, null)

				options = mapFrom(response[0].value)
				callback(null, options)
			)

	save: (options, callback) ->
		id = options.id
		revision = options.revision
		
		prepareForPersistence(options)

		database().save(id, revision, options, 
			(error, response) -> 
				if error
					return callback(error)
				
				callback(null, 
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
		shoes: 
			wearThreshold: document.shoes.wearThreshold
		user: document.user

	prepareForPersistence = (options) ->
		options['type'] = 'options'
		delete options.id
		delete options.revision

exports.options = new Options()