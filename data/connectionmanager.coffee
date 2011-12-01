cradle = require('cradle')

module.exports = class ConnectionManager
	@getConnection: ->
		unless @connection?
			@connection = new cradle.Connection()
		
		@connection