cradle = require('cradle')
connectionManager = require('./connectionmanager')
_ = require('underscore')

module.exports = class Shoes
	_database = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')

	getAll: (callback) ->
		_database.view('shoes/all', { descending: true }, 
			(error, response) ->
				if error
					return callback(error)

				shoesInUse = _(response).map((document) -> mapFrom(document.value))
			
				callback(error, shoesInUse)
			)

	getShoesInUse: (callback) ->
		_database.view('shoes/inUse', { descending: true }, (error, response) ->
			if error
				return callback(error)

			shoesInUse = _(response).map((document) -> mapFrom(document.value))
		
			callback(error, shoesInUse)
		)

	mapFrom = (document) ->
		id: document._id
		revision: document._rev
		color: document.color
		distance: document.distance
		inUse: document.inUse
		name: document.name
		purchaseDate: document.purchaseDate
		size: document.size
		status: document.status