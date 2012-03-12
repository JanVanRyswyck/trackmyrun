bootstrapper = require('./bootstrapper')
express = require('express')
require('./extensions')

# TODO: Test
bootstrapper.bootstrapAuthentication()
application = express.createServer()

application.configure ->
	bootstrapper.bootstrap(application)

application.listen(2536)