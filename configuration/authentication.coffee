passport = require('passport')
configuration = require('./configuration')
errors = require('../errors')
TwitterStrategy = require('passport-twitter').Strategy
Users = require('../data/users')

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
	users = new Users()
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
	users = new Users()
	user = users.getById(id, (error, user) ->
		if(error)
			return done(error)

		done(null, user)
	)
)