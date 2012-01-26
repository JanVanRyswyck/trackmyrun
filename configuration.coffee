fileSystem = require('fs')

module.exports = class Configuration
	@settings = null;

	@couchDBSettings: (callback) -> 
		if !@settings
			fileSystem.readFile('./config.json', 'utf8', (error, data) ->
				if error
					process.nextTick(-> callback(error))

				@settings = JSON.parse(data)
				
				process.nextTick(=> callback(error, @settings.couchDB))
			)
		else
			process.nextTick(=> callback(error, @settings.couchDB))