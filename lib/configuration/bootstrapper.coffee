exports.bootstrap = (application) ->
	require('./authentication').bootstrap()
	require('./middleware').bootstrap(application)
	require('./routes').bootstrap(application)
	require('./couchdb').bootstrap()

