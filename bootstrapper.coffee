express = require('express')
cradle = require('cradle')
configuration = require('./configuration')
errors = require('./errors')
_ = require('underscore')

routes = require('./routes')
routes.runs = _.extend(require('./routes/runs'), 
					   require('./routes/runs/new'))

validators = {}
validators.newRun = require('./validators/newrun')


exports.bootstrap = (application) ->
	bootstrapExpress(application)
	bootstrapRoutes(application)
	bootstrapCouchDB()

bootstrapExpress = (application) ->
	application.set('view engine', 'jade')
	application.use(express.bodyParser())
	application.use(express.static(__dirname + '/public'))
	application.use(express.errorHandler( dumpExceptions: true, showStack: true ))	
	application.use(express.cookieParser())
	application.use(express.session({ secret: 'fluppe' }))

bootstrapRoutes = (application) ->
	application.get('/', routes.index)
	application.get('/runs/new', routes.runs.new)
	application.post('/runs', validators.newRun.validate, routes.runs.create)
	application.get('/runs/:year?', routes.runs.index)

bootstrapCouchDB = ->
	configuration.couchDBSettings((error, couchDB) -> 
		if(error)
			throw new errors.ConfigurationError('An error occured while reading the configuration settings for the CouchDB database.', error)

		cradle.setup(
			host: couchDB.url
			port: couchDB.port
			auth: 
				username: couchDB.userName
				password: couchDB.password 
		)
	)
			
