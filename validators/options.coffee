form = require('express-form')

exports.validate = form(
	form.filter('wearThreshold').toInt()
	form.validate('wearThreshold').isNumeric('Please specify a wear threshold.')
)