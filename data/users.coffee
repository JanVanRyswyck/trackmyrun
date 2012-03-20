connectionManager = require('./connectionmanager')
_ = require('underscore')

module.exports = class Shoes
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

				if(0 == response.length)
					return callback(error, null)

				user = mapFrom(response[0].value)
				callback(null, user)	
			)

	mapFrom = (document) ->
		id: document._id
		displayName: document.displayName