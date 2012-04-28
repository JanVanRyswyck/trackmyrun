connectionManager = require('./connectionmanager')
_ = require('underscore')

class Users
	_database = null

	getById: (id, callback) ->
		database().get(id, (error, response) ->
			if error
				return callback(error)
			
			shoes = mapFrom(response)	
			callback(null, shoes)
		)

	getByName: (name, authority, callback) ->
		database().view('users/usersByName', { key: [name, authority] }, 
			(error, response) ->
				if error
					return callback(error)

				if(_(response).isEmpty() || 1 != response.length)
					errorMessage = 'The user with name "' + name + '" could not be found in the data store.'
					return callback(errorMessage, null)

				user = mapFrom(response[0].value)
				callback(null, user)	
			)

	database = () ->
		return _database if _database

		connection = connectionManager.getConnection()
		return _database = connection.database('trackmyrun')

	mapFrom = (document) ->
		id: document._id
		displayName: document.displayName

exports.users = new Users()

	