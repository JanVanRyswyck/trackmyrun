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
			callback(error, shoes)
		)

	getAll: (callback) ->
		_database.view('shoes/all', { descending: true }, 
			(error, response) ->
				if error
					return callback(error)

				shoesInUse = _(response).map((document) -> mapFrom(document.value))
				callback(error, shoesInUse)
			)

	getShoesInUse: (callback) ->
		_database.view('shoes/inUse', { descending: true }, 
			(error, response) ->
				if error
					return callback(error)

				shoesInUse = _(response).map((document) -> mapFrom(document.value))
				callback(error, shoesInUse)
			)

	save: (shoes, callback) ->
		id = shoes.id
		revision = shoes.revision

		prepareForPersistence(shoes)

		_database.save(id, revision, shoes, 
			(error, response) -> 
				if error
					return callback(error)
				
				callback(error, 
					id: response.id
					revision: response.revision
				)
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

	prepareForPersistence = (shoes) ->
		shoes['type'] = 'shoe'
		delete shoes.id
		delete shoes.revision