passport = require('passport')
configuration = require('./configuration')
errors = require('../errors')
TwitterStrategy = require('passport-twitter').Strategy
users = require('../data/users').users

exports.bootstrap = ->
	configuration.authenticationSettings((error, authentication) ->
		if error
			throw new errors.ConfigurationError('An error occured while reading the configuration settings for authenticating users.', error)

		passport.use(new TwitterStrategy(
		    consumerKey: authentication.twitter.consumerKey
		    consumerSecret: authentication.twitter.consumerSecret
		    callbackURL: authentication.twitter.callbackUrl		
		, verifyUser))
	)

verifyUser = (token, tokenSecret, profile, done) ->
	users.getByName(profile.username, "twitter", 
		(error, user) ->
			if error
				return done(error)

			if !user
				return done(null, false)

			done(null, user)	
		)

passport.serializeUser((user, done) ->
	done(null, user.id)
)

passport.deserializeUser((id, done) ->
	user = users.getById(id, (error, user) ->
		if(error)
			return done(error)

		done(null, user)
	)
)