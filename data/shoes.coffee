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
				return process.nextTick(-> callback(error))	
			
			shoes = mapFrom(response)	
			process.nextTick(-> callback(error, shoes))
		)

	getAll: (callback) ->
		_database.view('shoes/all', { descending: true }, 
			(error, response) ->
				if error
					return process.nextTick(-> callback(error))

				shoesInUse = _(response).map((document) -> mapFrom(document.value))
				process.nextTick(-> callback(error, shoesInUse))
			)

	getShoesInUse: (callback) ->
		_database.view('shoes/inUse', { descending: true }, (error, response) ->
				if error
					return process.nextTick(-> callback(error))

				shoesInUse = _(response).map((document) -> mapFrom(document.value))
				process.nextTick(-> callback(error, shoesInUse))
			)

	save: (shoes, callback) ->
		shoes['type'] = 'shoe'

		_database.save(shoes.id, shoes.revision, shoes, 
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
		color: document.color
		distance: document.distance
		inUse: document.inUse
		name: document.name
		purchaseDate: document.purchaseDate
		size: document.size
		status: document.status