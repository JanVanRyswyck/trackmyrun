step = require('step')
errors = require('../../errors')
Options = require('../../data/options')

exports.index = (request, response, next) -> 
	startShowOptionsFlow(request, response, next)

exports.update = (request, response, next) ->
	if not request.form.isValid 
		return renderViewForInvalidOptions(request, response)
	
	startUpdateOptionsFlow(request, response, next)	

startShowOptionsFlow = (request, response, next) ->
	step(
		getOptions = -> get(@)
		renderView = (error, options) -> 
			if error
				return next new errors.DataError('An error occured while loading data for the index page (options).', error)

			if not options
				return saveDefaultOptions((error, defaultOptions)->
					if error
						return next new errors.PersistenceError('An error occured while creating default options in the data store.', error)
					
					renderTheView(response, defaultOptions)		
				)
							
			renderTheView(response, options)	
	)

renderViewForInvalidOptions = (request, response) ->
	invalidOptions = mapOptionsForm(response.locals())
	invalidOptions['id'] = request.params.id
	
	renderTheView(response, invalidOptions, request.form.getErrors())

startUpdateOptionsFlow = (request, response, next) ->
	step(
		getOptions = -> get(@)

		updateOptions = (error, currentOptions) ->
			if error
				return next new errors.DataError('An error occured while loading the data for updating the options.', error)

			applyChangesTo(currentOptions, request.form)
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
			process.nextTick(-> callback(error))

		defaultOptions['id'] = data.id
		defaultOptions['revision'] = data.revision

		process.nextTick(-> callback(error, defaultOptions))
	)

get = (callback) ->
	options = new Options()
	options.get(callback)

save = (currentOptions, callback) ->
	options = new Options()
	options.save(currentOptions, callback)

renderTheView = (response, options, validationErrors = {}) ->
	response.render('options/index',
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
