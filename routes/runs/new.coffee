step = require('step')
_ = require('underscore')
errors = require('../../errors')
Runs = require('../../data/runs')
Shoes = require('../../data/shoes')
Calculator = require('../../services/calculator')

exports.new = (request, response, next) ->
	renderViewForNewRun(request.user, response, next)

exports.create = (request, response, next) ->
	if not request.form.isValid		
		return renderViewForNewRun(request.user, response, next, request.form.getErrors())

	createRunFlow(request.form, response, next)

renderViewForNewRun = (user, response, next, validationErrors) ->
	step(
		loadData = -> 
			shoes = new Shoes()
			shoes.getShoesInUse(@)

		renderView = (error, shoesInUse) ->
			if error 
				return next new errors.DataError('An error occured while loading data for the new run page.', error)
				
			run = if validationErrors then mapNewRunFrom(response.locals()) else createDefaultRun()
						
			response.render('runs/new',
				run: run
				pairsOfShoes: shoesInUse or []
				validationErrors: validationErrors or {}
			)
	)

createRunFlow = (formData, response, next) ->
	step(
		createRun = () ->
			newRun = mapNewRunFrom(formData)
			newRun.speed = new Calculator().calculateSpeedFor(newRun)
			
			runs = new Runs()	
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

mapNewRunFrom = (formData) ->
	date: formData.date
	distance: formData.distance
	duration:
		hours: 	formData.durationHours
		minutes: formData.durationMinutes
		seconds: formData.durationSeconds
	averageHeartRate: formData.averageHeartRate
	shoes: formData.shoes		
	comments: formData.comments