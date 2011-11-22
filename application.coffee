express = require('express')
application = express.createServer()

# TODO: Refactor into bootstrapper
application.configure(->
	application.set('view engine', 'jade')
	application.use(express.static(__dirname + '/public'));	 
)

# TODO: refactor into seperate controller class
application.get('/', (request, response)-> 
	response.render('index')
)

application.listen(2536)