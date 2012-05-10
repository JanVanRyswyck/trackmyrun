bootstrapper = require('./configuration/bootstrapper')
express = require('express')
require('./extensions')

application = express.createServer()

application.configure ->
	bootstrapper.bootstrap(application)

port = process.env.PORT or 2536;
application.listen(port)