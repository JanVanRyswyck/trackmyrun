connectionManager = require('./connectionmanager')
_ = require('underscore')

class Shoes
	_database = null

	getById: (id, callback) ->
		database().get(id, (error, response) ->
			if error
				return callback(error)
			
			shoes = mapFrom(response)	
			callback(null, shoes)
		)

	getAll: (user, callback) ->
		database().view('shoes/all', { startkey: [user.id, {}], endkey: [user.id], descending: true }, 
			(error, response) ->
				if error
					return callback(error)

				shoesInUse = _(response).map((document) -> mapFrom(document.value))
				callback(null, shoesInUse)
			)

	getShoesInUse: (user, callback) ->
		database().view('shoes/inUse', { startkey: [user.id, {}], endkey: [user.id], descending: true }, 
			(error, response) ->
				if error
					return callback(error)

				shoesInUse = _(response).map((document) -> mapFrom(document.value))
				callback(null, shoesInUse)
			)

	save: (shoes, callback) ->
		id = shoes.id
		revision = shoes.revision

		prepareForPersistence(shoes)

		database().save(id, revision, shoes, 
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
		color: document.color
		distance: document.distance
		inUse: document.inUse
		lastStatusUpdate: document.lastStatusUpdate
		name: document.name
		purchaseDate: document.purchaseDate
		size: document.size
		status: document.status
		user: document.user

	prepareForPersistence = (shoes) ->
		shoes['type'] = 'shoe'
		delete shoes.id
		delete shoes.revision

exports.shoes = new Shoes()