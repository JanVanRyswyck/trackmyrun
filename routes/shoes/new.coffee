step = require('step')
_ = require('underscore')
errors = require('../../errors')
shoes = require('../../data/shoes')

exports.new = (request, response) ->
	renderViewForNewShoes(request, response)

exports.create = (request, response, next) ->
	if not request.form.isValid		
		return renderViewForNewShoes(request, response)

	createShoesFlow(request, response, next)

renderViewForNewShoes = (request, response) ->
	validationErrors = request.form.getErrors() if request.method == 'POST'
	newPairOfShoes = if validationErrors then mapNewShoesFrom(response.locals(), request.user) else createDefaultShoes()

	response.render('shoes/new',
		currentUser: request.user
		shoes: newPairOfShoes
		validationErrors: validationErrors or {}
	)

createShoesFlow = (request, response, next) ->
	step(
		createShoes = () ->
			newPairOfShoes = mapNewShoesFrom(request.form, request.user)
			shoes.save(newPairOfShoes, @)

		redirectToIndex = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while creating a new pair of shoes in the data store.', error)

			response.redirect('/shoes')	
	)

createDefaultShoes = () ->
	color: ''
	name: ''
	purchaseDate: _.getCurrentDate()
	size: ''

mapNewShoesFrom = (formData, user) ->
	color: formData.color
	distance: 0
	inUse: true
	name: formData.name
	purchaseDate: formData.purchaseDate
	size: formData.size
	status: 'OK'
	user: user.id	