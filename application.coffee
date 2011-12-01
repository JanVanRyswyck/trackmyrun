express = require('express')
bootstrapper = require('./bootstrapper')
errors = require('./errors')
application = express.createServer()

Shoes = require('./data/shoes')

application.configure ->
	bootstrapper.bootstrap(application)

# TODO: refactor into seperate controller class
application.get('/', (request, response)-> 
	shoes = new Shoes();
	shoes.getShoesInUse((error, shoesInUse) -> 
		console.log 'Error: ' + error
		if(error)
			throw new errors.DataError('An error occured while retrieving the shoes that are currently in use.', error)

		response.render('index', shoesInUse: shoesInUse)
	)
)

application.listen(2536)