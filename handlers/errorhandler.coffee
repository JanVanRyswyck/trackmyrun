errors = require('../errors')
util = require('util')

_applicationSettings = null

exports.bootstrap = (application) ->
	_applicationSettings = application.settings

	application.use(onPageNotFound)
	application.error(onError)

onPageNotFound = (request, response, next) ->
	next(new errors.PageNotFoundError())

onError = (error, request, response, next) ->
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

