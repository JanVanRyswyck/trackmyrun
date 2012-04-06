connectionManager = require('../data/connectionmanager')

exports.bootstrap = ->
	connection = connectionManager.getConnection()
	database = connection.database('trackmyrun')

	changesFeed = database.changes(caught_up: true)

	changesFeed.on('change', (change) ->
		console.log 'Change event:'
		console.log change
	)

	changesFeed.on('catchup', (seq_id) ->
		console.log 'Catchup event:'
		console.log seq_id
	)

	changesFeed.on('error', (error) ->
		console.log 'Error event:'
		console.log error
	)
