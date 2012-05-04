class exports.ConfigurationError extends Error
	constructor: (message, @error) ->
		super message
		Error.captureStackTrace(@, arguments.callee);

class exports.DataError extends Error
	constructor: (message, @error) ->
		super message
		Error.captureStackTrace(@, arguments.callee);

class exports.PersistenceError extends Error
	constructor: (message, @error) ->
		super message
		Error.captureStackTrace(@, arguments.callee);	
