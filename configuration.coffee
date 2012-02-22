fileSystem = require('fs')

module.exports = class Configuration
	@settings = null;

	@getSettings = (callback) ->
		if @settings
			return process.nextTick(=> callback(null, @settings))

		fileSystem.readFile('./config.json', 'utf8', (error, data) ->
			if error
				return process.nextTick(-> callback(error))

			@settings = JSON.parse(data)
			process.nextTick(=> callback(error, @settings))
		)

	@couchDBSettings: (callback) -> 
		@getSettings((error, settings)->
				if error
					return callback(error)

				callback(error, settings.couchDB)
			)

	@authenticationSettings: (callback) ->
		@getSettings((error, settings)->
				if error
					return callback(error)

				callback(error, settings.authentication)
			)		




	
