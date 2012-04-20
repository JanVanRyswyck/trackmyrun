
exports.ensureAuthenticated = (request, response, next) ->
	return next() if request.user
	response.redirect('/auth/twitter')

exports.signOut = (request, response) ->
	request.logOut()
	response.redirect('/')