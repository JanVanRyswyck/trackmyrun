step = require('step')
errors = require('../../errors')
Options = require('../../data/options')

exports.index = (request, response, next) -> 
	renderViewForOptions(request, response, next)

exports.update = (request, response, next) ->
	if not request.form.isValid 
		return renderViewForInvalidOptions(request, response)
	
	updateOptionsFlow(request.user, request.form, response, next)	

renderViewForOptions = (request, response, next) ->
	step(
		getOptions = -> get(request.user, @)
		renderView = (error, options) -> 
			if error
				return next new errors.DataError('An error occured while loading data for the index page (options).', error)

			if not options
				return saveDefaultOptions((error, defaultOptions)->
					if error
						return next new errors.PersistenceError('An error occured while creating default options in the data store.', error)
					
					renderTheView(response, request.user, defaultOptions)		
				)
							
			renderTheView(response, request.user, options)	
	)

renderViewForInvalidOptions = (request, response) ->
	invalidOptions = mapOptionsForm(response.locals())
	invalidOptions['id'] = request.params.id
	
	validationErrors = request.form.getErrors()
	renderTheView(response, request.user invalidOptions, validationErrors)

updateOptionsFlow = (user, formData, response, next) ->
	step(
		getOptions = -> get(user, @)

		updateOptions = (error, currentOptions) ->
			if error
				return next new errors.DataError('An error occured while loading the data for updating the options.', error)

			applyChangesTo(currentOptions, formData)
			save(currentOptions, @)

		redirectToOptions = (error) ->
			if error
				return next new errors.PersistenceError('An error occured while saving options in the data store.', error)

			response.redirect('/options')	
	)

saveDefaultOptions = (callback) ->
	defaultOptions = createDefaultOptions()

	save(defaultOptions, (error, data) ->
		if error
			return callback(error)

		defaultOptions['id'] = data.id
		defaultOptions['revision'] = data.revision

		callback(error, defaultOptions)
	)

get = (user, callback) ->
	options = new Options()
	options.get(user, callback)

save = (currentOptions, callback) ->
	options = new Options()
	options.save(currentOptions, callback)

renderTheView = (response, user, options, validationErrors = {}) ->
	response.render('options/index',
		currentUser: user
		options: options
		validationErrors: validationErrors
	)

applyChangesTo = (options, formData) ->
	options.shoes.wearThreshold = formData.wearThreshold

mapOptionsForm = (formData) ->
	shoes: 
		wearThreshold: formData.wearThreshold

createDefaultOptions = ->
	shoes:
		wearThreshold: 1000
