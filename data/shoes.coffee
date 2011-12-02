cradle = require('cradle')
connectionManager = require('./connectionmanager')
_ = require('underscore')

module.exports = class Shoes
	_database = null

	constructor: ->
		connection = connectionManager.getConnection()
		_database = connection.database('trackmyrun')

	getShoesInUse: (callback) ->
		_database.view('shoes/inUse', (error, response) ->
			if error
				return callback(error)

			shoesInUse = _.map(response, 
				(document) ->
					id: document.value._id
					name: document.value.name
			)
		
			callback(error, shoesInUse)
		)



	