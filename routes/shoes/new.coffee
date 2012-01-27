step = require('step')
_ = require('underscore')
errors = require('../../errors')
Shoes = require('../../data/shoes')

exports.new = (request, response) ->
	renderViewForNewShoes(response)

exports.create = (request, response) ->
	if not request.form.isValid		
		renderViewForNewShoes(response, request.form.getErrors())
		return

	step(
		createShoes = () ->
			newShoes = mapNewShoesFrom(request.form)
								
			shoes = new Shoes()	
			shoes.save(newShoes, @)

		redirectToIndex = (error) ->
			if error
				throw new errors.PersistenceError('An error occured while creating a new pair of shoes in the data store.', error)

			response.redirect('/shoes')	
	)

renderViewForNewShoes = (response, validationErrors) ->
	shoes = createDefaultShoes()
	if(validationErrors)
		shoes = mapNewShoesFrom(response.locals())

	response.render('shoes/new',
		shoes: shoes
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