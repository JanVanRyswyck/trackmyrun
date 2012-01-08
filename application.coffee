bootstrapper = require('./bootstrapper')
express = require('express')
require('./extensions')

application = express.createServer()

application.configure ->
	bootstrapper.bootstrap(application)

application.listen(2536)