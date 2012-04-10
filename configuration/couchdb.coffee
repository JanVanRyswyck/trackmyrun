cradle = require('cradle')
configuration = require('./configuration')
errors = require('../errors')

exports.bootstrap = ->
	configuration.couchDBSettings((error, couchDB) -> 
		if error
			throw new errors.ConfigurationError('An error occured while reading the configuration settings for the CouchDB database.', error)

		cradle.setup(
			host: couchDB.url
			port: couchDB.port
			auth: 
				username: couchDB.userName
				password: couchDB.password 
		)

		# TODO Jan: Test (put in handler??)
		# require('../handlers/changeshandler').bootstrap()
	)