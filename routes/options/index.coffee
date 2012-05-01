step = require('step')
errors = require('../../errors')
options = require('../../data/options').options

exports.index = (request, response, next) -> 
	renderViewForOptions(request, response, next)

exports.update = (request, response, next) ->
	if not request.form.isValid 
		return renderViewForInvalidOptions(request, response)
	
	updateOptionsFlow(request, response, next)	

renderViewForOptions = (request, response, next) ->
	step(
		getOptions = -> options.get(request.user, @)
		renderView = (error, currentOptions) -> 
			if error
				return next new errors.DataError('An error occured while loading data for the index page (options).', error)

			if not currentOptions
				return saveDefaultOptions(request.user, (error, defaultOptions)->
					if error
						return next new errors.PersistenceError('An error occured while creating default options in the data store.', error)
					
					renderTheView(response, request.user, defaultOptions)		
				)
							
			renderTheView(response, request.user, currentOptions)	
	)

renderViewForInvalidOptions = (request, response) ->
	invalidOptions = mapOptionsForm(response.locals())
	invalidOptions['id'] = request.params.id
	
	validationErrors = request.form.getErrors() if request.method is 'PUT'
	renderTheView(response, request.user, invalidOptions, validationErrors)

updateOptionsFlow = (request, response, next) ->
	step(
		getOptions = -> options.get(request.user, @)

		updateOptions = (error, currentOptions) ->
			if error
				return next new errors.DataError('An error occured while loading the data for updating the options.', error)

			applyChangesTo(currentOptions, request.form)
			options.save(currentOptions, @)

		redirectToOptions = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while saving options in the data store.', error)

			response.redirect('/options')	
	)

saveDefaultOptions = (user, callback) ->
	defaultOptions = createDefaultOptionsFor(user)

	options.save(defaultOptions, (error, data) ->
		if error
			return callback(error)

		defaultOptions['id'] = data.id
		defaultOptions['revision'] = data.revision

		callback(error, defaultOptions)
	)

renderTheView = (response, user, userOptions, validationErrors = {}) ->
	response.render('options/index',
		currentUser: user
		options: userOptions
		validationErrors: validationErrors
	)

applyChangesTo = (currentOptions, formData) ->
	currentOptions.shoes.wearThreshold = formData.wearThreshold

mapOptionsForm = (formData) ->
	shoes: 
		wearThreshold: formData.wearThreshold

createDefaultOptionsFor = (user) ->
	shoes:
		wearThreshold: 1000
	user: user.id
