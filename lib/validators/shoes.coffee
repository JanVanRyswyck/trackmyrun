form = require('express-form')

exports.validate = form(
	form.filter('name').trim()
	form.validate('name').notEmpty('Please specify a valid name.')

	form.filter('size').toFloat()
	form.validate('size').isNumeric('Please specify a valid size.')

	form.filter('color').trim()

	form.filter('purchaseDate').trim()
	form.validate('purchaseDate')
		.regex(/^(19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$/, 
			   'Please specify a valid purchase date (e.g. 2012-02-06).')
	
	form.filter('inUse').toBoolean()
)