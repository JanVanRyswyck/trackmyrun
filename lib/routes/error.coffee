errors = require('../errors')
util = require('util')

module.exports = (application) ->
	_applicationSettings = application.settings

	onPageNotFound: (request, response, next) ->
		response.render('404', 
			currentUser: request.user
			status: 404
		)

	onError: (error, request, response, next) ->
		response.render('500',
			currentUser: request.user 
			status: 500,
			error: util.inspect(error),
			showDetails: _applicationSettings.showErrorDetails	
		)

