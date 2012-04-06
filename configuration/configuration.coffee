fileSystem = require('fs')

module.exports = class Configuration
	@settings = null;

	@getSettings = (callback) ->
		if @settings
			return process.nextTick(=> callback(null, @settings))

		fileSystem.readFile(__dirname + '/config.json', 'utf8', (error, data) ->
			if error
				callback(error)

			@settings = JSON.parse(data)
			callback(null, @settings)
		)

	@authenticationSettings: (callback) ->
		@getSettings((error, settings)->
				if error
					return callback(error)

				callback(null, settings.authentication)
			)		

	@couchDBSettings: (callback) -> 
		@getSettings((error, settings)->
				if error
					return callback(error)

				callback(null, settings.couchDB)
			)

	
