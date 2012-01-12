cradle = require('cradle')
connectionManager = require('./connectionmanager')
_ = require('underscore')

module.exports = class Shoes
	_database = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')

	getAll: (callback) ->
		_database.view('shoes/all', (error, response) ->
			if error
				return callback(error)

			shoesInUse = _(response).map((document) -> mapFrom(document.value))
		
			callback(error, shoesInUse)
		)

	getShoesInUse: (callback) ->
		_database.view('shoes/inUse', (error, response) ->
			if error
				return callback(error)

			shoesInUse = _(response).map((document) -> mapFrom(document.value))
		
			callback(error, shoesInUse)
		)

	mapFrom = (document) ->
		id: document._id
		name: document.name



	