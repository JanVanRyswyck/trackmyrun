step = require('step')
_ = require('underscore')
errors = require('../../errors')
runs = require('../../data/runs')
shoes = require('../../data/shoes')
Calculator = require('../../services/calculator')

exports.new = (request, response, next) ->
	renderViewForNewRun(request, response, next)

exports.create = (request, response, next) ->
	if not request.form.isValid		
		return renderViewForNewRun(request, response, next)

	createRunFlow(request, response, next)

renderViewForNewRun = (request, response, next) ->
	step(
		loadData = -> 
			shoes.getShoesInUse(request.user, @)

		renderView = (error, shoesInUse) ->
			if error 
				return next new errors.DataError('An error occured while loading data for the new run page.', error)
			
			validationErrors = request.form.getErrors() if request.method == 'POST'
			run = if validationErrors then mapNewRunFrom(response.locals(), request.user) else createDefaultRun()
						
			response.render('runs/new',
				currentUser: request.user
				run: run
				pairsOfShoes: shoesInUse or []
				validationErrors: validationErrors or {}
			)
	)

createRunFlow = (request, response, next) ->
	step(
		createRun = () ->
			newRun = mapNewRunFrom(request.form, request.user)
			newRun.speed = new Calculator().calculateSpeedFor(newRun)
	
			runs.save(newRun, @)

		redirectToIndex = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while creating a new run in the data store.', error)

			response.redirect('/runs')	
	)

createDefaultRun = () ->
	date: _.getCurrentDate()
	distance: ''
	duration:
		hours: ''
		minutes: ''
		seconds: ''
	averageHeartRate: 0
	shoes: -1
	comments: ''

mapNewRunFrom = (formData, user) ->
	date: formData.date
	distance: formData.distance
	duration:
		hours: 	formData.durationHours
		minutes: formData.durationMinutes
		seconds: formData.durationSeconds
	averageHeartRate: formData.averageHeartRate
	shoes: formData.shoes		
	comments: formData.comments
	user: user.id