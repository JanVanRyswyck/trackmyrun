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

class exports.PageNotFoundError extends Error
	constructor: ->
		super 'Page not found'
		Error.captureStackTrace(@, arguments.callee);		
