config = require 'config'
expressJwt = require 'express-jwt'
jwt = require 'jsonwebtoken'

secret = config.get 'jsonWebToken.secret'

module.exports =
  signUser: (user) ->
    jwt.sign user, secret

  authenticate: expressJwt {
    secret: secret
    credentialsRequired: false
  }

  mwChainOr: (testCb, elseMw) ->
    (req, res, next) ->
      testCb req, (error, result) ->
        return next error if error
        return next() if result
        return elseMw req, res, next if elseMw
        res.sendStatus 401

  mwChainAnd: (testCb, elseMw) ->
    (req, res, next) ->
      testCb req, (error, result) ->
        return next error if error
        return elseMw req, res, next if result and elseMw
        return next() if result
        res.sendStatus 401


  isUser: (testFn) ->
    (req, res, next) ->
      return next() if testFn req.user
      res.sendStatus 401
