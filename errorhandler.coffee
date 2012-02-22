errors = require('./errors')
util = require('util')

exports.bootstrap = (application) ->
	errorHandler = new ErrorHandler(application.settings)
	application.use(errorHandler.onPageNotFound)
	application.error(errorHandler.onError)

class ErrorHandler
	_applicationSettings = null

	constructor: (applicationSettings) ->
		_applicationSettings = applicationSettings

	onPageNotFound: (request, response, next) ->
		next(new errors.PageNotFoundError())	

	onError: (error, request, response, next) ->
		if error instanceof errors.PageNotFoundError
			response.render('404', 
				status: 404
			)
		else 
			response.render('500', 
				status: 500,
				error: util.inspect(error),
				showDetails: _applicationSettings.showStackTrace	
			)

