passport = require('passport')
_ = require('underscore')

routes = _.extend(require('../routes'),
		 		  require('../routes/authentication'))
routes.runs = _.extend(require('../routes/runs'), 
					   require('../routes/runs/new'),
					   require('../routes/runs/edit'))
routes.shoes = _.extend(require('../routes/shoes'),
						require('../routes/shoes/new'),
						require('../routes/shoes/edit'))
routes.shoes.wear = require('../routes/shoes/wear')
routes.options = require('../routes/options')

validators = {}
validators.run = require('../validators/run')
validators.shoes = require('../validators/shoes')
validators.options = require('../validators/options')

exports.bootstrap = (application) ->
	registerAuthenticationRoutes(application)
	registerApplicationRoutes(application)
	registerErrorHandler(application)

registerAuthenticationRoutes = (application) ->
	application.all('/runs*', routes.ensureAuthenticated)
	application.all('/shoes*', routes.ensureAuthenticated)
	application.all('/options*', routes.ensureAuthenticated)

	application.get('/auth/twitter', passport.authenticate('twitter'))
	application.get('/auth/twitter/callback', passport.authenticate('twitter', { successRedirect: '/', failureRedirect: '/' }))
	application.get('/logout', routes.signOut)

registerApplicationRoutes = (application) ->
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
	application.get('/shoes/wear/:id([a-z0-9]{32})', routes.shoes.wear.update)

	application.get('/options', routes.options.index)
	application.put('/options/:id([a-z0-9]{32})', validators.options.validate, routes.options.update)
			
registerErrorHandler = (application) ->
	errorHandler = require('../routes/error')(application)

	application.use(errorHandler.onPageNotFound)
	application.use(errorHandler.onError)