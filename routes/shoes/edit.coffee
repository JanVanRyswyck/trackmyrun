step = require('step')
errors = require('../../errors')
shoes = require('../../data/shoes').shoes

exports.edit = (request, response, next) ->
	renderViewForEditShoes(request, response, next)

exports.update = (request, response, next) ->
	if not request.form.isValid
		return renderViewForEditShoes(request, response, next)

	updateShoesFlow(request, response, next)

renderViewForEditShoes = (request, response, next) ->
	shoesId = request.params.id
	validationErrors = request.form.getErrors() if request.method is 'PUT'

	step(
		loadData = ->
			return @() if validationErrors
			shoes.getById(shoesId, @)

		renderView = (error, pairOfShoes) ->
			if error
				return next new errors.DataError('An error occured while loading data for the edit pair of shoes page.', error)

			if validationErrors
				pairOfShoes = mapShoesFrom(response.locals())
				pairOfShoes['id'] = shoesId
				
			response.render('shoes/edit',
				currentUser: request.user 
				shoes: pairOfShoes
				validationErrors: validationErrors or {}
			)
	)

updateShoesFlow = (request, response, next) ->
	step(
		getShoes = ->
			shoesId = request.params.id
			shoes.getById(shoesId, @)

		updateShoes = (error, pairOfShoes) ->
			if error
				return next new errors.DataError('An error occured while loading the data for updating a pair of shoes.', error)

			applyChangesTo(pairOfShoes, request.form)
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