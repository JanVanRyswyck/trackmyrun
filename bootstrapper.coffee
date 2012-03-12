express = require('express')
cradle = require('cradle')
everyauth = require('everyauth')
_ = require('underscore')
configuration = require('./configuration')
viewHelpers = require('./views/viewhelpers')
errors = require('./errors')
errorHandler = require('./errorhandler')

routes = require('./routes')
routes.runs = _.extend(require('./routes/runs'), 
					   require('./routes/runs/new'),
					   require('./routes/runs/edit'))
routes.shoes = _.extend(require('./routes/shoes'),
						require('./routes/shoes/new'),
						require('./routes/shoes/edit'))
routes.options = require('./routes/options')

validators = {}
validators.run = require('./validators/run')
validators.shoes = require('./validators/shoes')
validators.options = require('./validators/options')


exports.bootstrap = (application) ->
	# bootstrapAuthentication()
	bootstrapExpress(application)
	bootstrapRoutes(application)
	# TODO: Test
	# bootstrapErrorHandler(application)
	bootstrapCouchDB()

exports.bootstrapAuthentication = () ->
	configuration.authenticationSettings((error, authentication) ->
		if error
			throw new errors.ConfigurationError('An error occured while reading the configuration settings for authenticating users.', error)

		everyauth.twitter
			.consumerKey(authentication.twitter.consumerKey)
			.consumerSecret(authentication.twitter.consumerSecret)
			.findOrCreateUser(
				(session, accessToken, accessTokenSecret, twitterUser) ->
					console.log twitterUserData
					console.log accessToken
					console.log accessTokenSecret	

					return twitterUser
					# TODO: find user and if cannot be found, do not authenticate
				)
			.redirectPath('/')
	)
	
bootstrapExpress = (application) ->
	application.use(express.bodyParser())
	application.use(express.methodOverride())
	application.use(express.cookieParser())
	application.use(express.session( secret: '498f99f3bbee4ae3a075eada02499464' ))
	application.use(everyauth.middleware())
	application.use(application.router)
	application.use(express.static(__dirname + '/public'))
	application.use(express.errorHandler())
	
	everyauth.helpExpress(application)
	application.helpers(viewHelpers)

	application.set('view engine', 'jade')
	application.set('showStackTrace', application.settings.env == 'development')
	
bootstrapRoutes = (application) ->
	application.get('/', routes.index)

	application.post('/runs', validators.run.validate, routes.runs.create)
	application.get('/runs/new', routes.runs.new)
	application.get('/runs/:year([0-9]{4})?', routes.runs.index)
	application.put('/runs/:id([a-z0-9]{32})', validators.run.validate, routes.runs.update)
	application.get('/runs/:id([a-z0-9]{32})', routes.runs.edit)
	
	application.get('/shoes', routes.shoes.index)
	application.post('/shoes', validators.shoes.validate, routes.shoes.create)
	application.get('/shoes/new', routes.shoes.new)
	application.put('/shoes/:id([a-z0-9]{32})', validators.shoes.validate, routes.shoes.update)
	application.get('/shoes/:id([a-z0-9]{32})', routes.shoes.edit)

	application.get('/options', routes.options.index)
	application.put('/options/:id([a-z0-9]{32})', validators.options.validate, routes.options.update)

bootstrapErrorHandler = (application) ->
	errorHandler.bootstrap(application)

bootstrapCouchDB = ->
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
	)
			
