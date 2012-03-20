express = require('express')
passport = require('passport')
viewHelpers = require('../views/viewhelpers')

exports.bootstrap = (application) ->
	application.use(express.bodyParser())
	application.use(express.methodOverride())
	application.use(express.cookieParser())
	application.use(express.session( secret: '498f99f3bbee4ae3a075eada02499464' ))
	application.use(passport.initialize())
	application.use(passport.session())
	application.use(application.router)
	application.use(express.static(__dirname + '/../public'))
	application.use(express.errorHandler())
	
	application.helpers(viewHelpers)

	application.set('view engine', 'jade')
	application.set('showStackTrace', application.settings.env == 'development')