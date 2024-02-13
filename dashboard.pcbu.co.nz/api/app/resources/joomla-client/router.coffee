express = require 'express'

Client = require './Model'
Business = require '../business/Model'
auth = require '../../lib/authentication'
clientAuth = require '../../lib/clientAuthentication'

userCheck = (req, callback) ->
  callback null, req.user?

isUser = auth.mwChainOr userCheck

isUserOrClient = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
  )
)

isUserOrActiveClient = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      clientAuth.checkActive
    )
  )
)

checkClientIsSelf = checkAssignedClientEditable = clientAuth.checkAsyncCondition (req, client, callback) ->
  callback null, req.params?.id is '' + client.id

isUserOrClientSelf = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      checkClientIsSelf
    )
  )
)

module.exports = express()
.use auth.authenticate

.get '/', isUser, (req, res, next) ->
  Client.all (error, items) ->
    return next error if error
    res.json items

.get '/:id', isUserOrClientSelf, (req, res, next) ->
  Client.one req.params.id, (error, item) ->
    return next error if error
    res.json item

.get '/:id/check-session/:sessionId', (req, res, next) ->
  Client.isLoggedIn req.params.id, req.params.sessionId, (error, item) ->
    return next error if error
    res.json item
