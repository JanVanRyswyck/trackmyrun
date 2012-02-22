step = require('step')
_ = require('underscore')
errors = require('../../errors')
Shoes = require('../../data/shoes')

exports.new = (request, response) ->
	renderViewForNewShoes(response)

exports.create = (request, response, next) ->
	if not request.form.isValid		
		return renderViewForNewShoes(response, request.form.getErrors())

	step(
		createShoes = () ->
			newPairOfShoes = mapNewShoesFrom(request.form)
								
			shoes = new Shoes()	
			shoes.save(newPairOfShoes, @)

		redirectToIndex = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while creating a new pair of shoes in the data store.', error)

			response.redirect('/shoes')	
	)

renderViewForNewShoes = (response, validationErrors) ->
	newPairOfShoes = if validationErrors then mapNewShoesFrom(response.locals()) else createDefaultShoes()

	response.render('shoes/new',
		shoes: newPairOfShoes
		validationErrors: validationErrors or {}
	)

createDefaultShoes = () ->
	color: ''
	name: ''
	purchaseDate: _.getCurrentDate()
	size: ''

mapNewShoesFrom = (formData) ->
	color: formData.color
	distance: 0
	inUse: true
	name: formData.name
	purchaseDate: formData.purchaseDate
	size: formData.size
	status: 'OK'	