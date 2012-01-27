express = require('express')
cradle = require('cradle')
_ = require('underscore')
configuration = require('./configuration')
errors = require('./errors')
viewHelpers = require('./views/viewhelpers')

routes = require('./routes')
routes.runs = _.extend(require('./routes/runs'), 
					   require('./routes/runs/new'),
					   require('./routes/runs/edit'))
routes.shoes = _.extend(require('./routes/shoes'),
						require('./routes/shoes/new'))

validators = {}
validators.run = require('./validators/run')
validators.shoes = require('./validators/shoes')


exports.bootstrap = (application) ->
	bootstrapExpress(application)
	bootstrapRoutes(application)
	bootstrapCouchDB()

bootstrapExpress = (application) ->
	application.set('view engine', 'jade')
	application.use(express.bodyParser())
	application.use(express.methodOverride())
	application.use(express.static(__dirname + '/public'))
	application.use(express.errorHandler( dumpExceptions: true, showStack: true ))	
	application.use(express.cookieParser())
	application.use(express.session({ secret: 'fluppe' }))
	application.helpers(viewHelpers)

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
			
