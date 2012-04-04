passport = require('passport')

exports.bootstrap = (application) ->
	application.all('/runs*', ensureAuthenticated)
	application.all('/shoes*', ensureAuthenticated)
	application.all('/options*', ensureAuthenticated)

	application.get('/auth/twitter', passport.authenticate('twitter'))
	application.get('/auth/twitter/callback', passport.authenticate('twitter', { successRedirect: '/', failureRedirect: '/' }))

ensureAuthenticated = (request, response, next) ->
	return next() if request.user
	response.redirect('/auth/twitter')