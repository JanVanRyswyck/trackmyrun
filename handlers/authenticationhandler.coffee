passport = require('passport')

exports.bootstrap = (application) ->
	application.all('/runs*', authenticate)
	application.all('/shoes*', authenticate)
	application.all('/options*', authenticate)

	application.get('/auth/twitter', passport.authenticate('twitter'))
	application.get('/auth/twitter/callback', passport.authenticate('twitter', { successRedirect: '/', failureRedirect: '/' }))

authenticate = (request, response, next) ->
	return next() if request.user
	response.redirect('/auth/twitter')