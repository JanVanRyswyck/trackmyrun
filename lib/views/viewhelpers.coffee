_ = require('underscore')

exports.shoeNameFor = (shoeId, shoes)  ->
	shoe = _(shoes).find((shoe) -> shoe.id is shoeId)
	if shoe then shoe.name else 'Unknown shoe'