step = require('step')
errors = require('../../errors')
Shoes = require('../../data/shoes')

exports.edit = (request, response, next) ->
	shoesId = request.params.id
	renderViewForEditShoes(shoesId, response, next)

exports.update = (request, response, next) ->
	shoesId = request.params.id
	
	if not request.form.isValid
		return renderViewForEditShoes(request.params.id, response, next, request.form.getErrors())

	updateShoesFlow(shoesId, request.form, response, next)

renderViewForEditShoes = (shoesId, response, next, validationErrors) ->
	step(
		loadData = ->
			return @() if validationErrors

			shoes = new Shoes() 
			shoes.getById(shoesId, @)

		renderView = (error, pairOfShoes) ->
			if error
				return next new errors.DataError('An error occured while loading data for the edit pair of shoes page.', error)

			if validationErrors
				pairOfShoes = mapShoesFrom(response.locals())
				pairOfShoes['id'] = shoesId
				
			response.render('shoes/edit', 
				shoes: pairOfShoes
				validationErrors: validationErrors or {}
			)
	)

updateShoesFlow = (shoesId, formData, response, next) ->
	shoes = new Shoes() 

	step(
		getShoes = ->
			shoes.getById(shoesId, @)

		updateShoes = (error, pairOfShoes) ->
			if error
				return next new errors.DataError('An error occured while loading the data for updating a pair of shoes.', error)

			applyChangesTo(pairOfShoes, formData)
			shoes.save(pairOfShoes, @)

		redirectToIndex = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while saving a pair of shoes in the data store.', error)

			response.redirect('/shoes')	
	)

applyChangesTo = (pairOfShoes, formData) ->
	pairOfShoes.color = formData.color
	pairOfShoes.name = formData.name
	pairOfShoes.inUse = formData.inUse	
	pairOfShoes.purchaseDate = formData.purchaseDate
	pairOfShoes.size = formData.size

mapShoesFrom = (formData) ->
	color: formData.color
	name: formData.name
	purchaseDate: formData.purchaseDate
	size: formData.size