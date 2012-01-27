step = require('step')
_ = require('underscore')
errors = require('../../errors')
Runs = require('../../data/runs')
Shoes = require('../../data/shoes')
Calculator = require('../../services/calculator')

exports.new = (request, response) ->
	renderViewForNewRun(response)

exports.create = (request, response) ->
	if not request.form.isValid		
		renderViewForNewRun(response, request.form.getErrors())
		return

	step(
		createRun = () ->
			newRun = mapNewRunFrom(request.form)
			newRun.speed = new Calculator().calculateSpeedFor(newRun)
			
			runs = new Runs()	
			runs.save(newRun, @)

		redirectToIndex = (error) ->
			if error
				throw new errors.PersistenceError('An error occured while creating a new run in the data store.', error)

			response.redirect('/runs')	
	)

renderViewForNewRun = (response, validationErrors) ->
	step(
		loadData = -> 
			shoes = new Shoes()
			shoes.getShoesInUse(@)

		renderView = (error, shoesInUse) ->
			if error 
				throw new errors.DataError('An error occured while loading data for the new run page.', error)

			run = createDefaultRun()
			if validationErrors
				run = mapNewRunFrom(response.locals())
						
			response.render('runs/new',
				run: run
				shoesInUse: shoesInUse or []
				validationErrors: validationErrors or {}
			)
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