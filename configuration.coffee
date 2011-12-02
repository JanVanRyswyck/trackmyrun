fileSystem = require('fs')

module.exports = class Configuration
	@settings = null;

	@couchDBSettings: (callback) -> 
		if !@settings
			fileSystem.readFile('./config.json', 'utf8', (error, data) ->
				if error
					return callback(error)

				@settings = JSON.parse data
				callback(error, @settings.couchDB)
			)
		else
			callback(error, @settings.couchDB)