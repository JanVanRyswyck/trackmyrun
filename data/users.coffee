connectionManager = require('./connectionmanager')
_ = require('underscore')

class Users
	_database = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')

	getById: (id, callback) ->
		_database.get(id, (error, response) ->
			if error
				return callback(error)
			
			shoes = mapFrom(response)	
			callback(null, shoes)
		)

	getByName: (name, authority, callback) ->
		_database.view('users/usersByName', { key: [name, authority] }, 
			(error, response) ->
				if error
					return callback(error)

				if(_(response).isEmpty() || 1 != response.length)
					errorMessage = 'The user with name "' + name + '" could not be found in the data store.'
					return callback(errorMessage, null)

				user = mapFrom(response[0].value)
				callback(null, user)	
			)

	mapFrom = (document) ->
		id: document._id
		displayName: document.displayName

module.exports = new Users()

	