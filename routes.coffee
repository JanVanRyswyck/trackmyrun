indexRoute = require('./routes/index').index
#TODO: use mixins for multiple routes?

exports.bootstrapFor = (application) ->
	application.get('/', indexRoute)