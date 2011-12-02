indexRoute = require('./routes/index').index
indexRunsRoute = require('./routes/runs/index').index
#TODO: use mixins for multiple routes?

exports.bootstrapFor = (application) ->
	application.get('/', indexRoute)
	application.get('/runs/:year?', indexRunsRoute)