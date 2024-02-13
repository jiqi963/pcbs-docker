express = require 'express'

Business = require './Model'
auth = require '../../lib/authentication'
clientAuth = require '../../lib/clientAuthentication'

userCheck = (req, callback) ->
  callback null, req.user?

# Authorization Middleware

isUser = auth.mwChainOr userCheck

isUserOrActiveClient = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      clientAuth.checkActive
    )
  )
)

checkAssignedClient = clientAuth.checkAsyncCondition (req, client, callback) ->
  Business.findById req.params.id, (error, business) ->
    callback null, business?.clientId is client.id

isUserOrActiveAssignedClient = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      clientAuth.checkActive
      auth.mwChainAnd(
        checkAssignedClient
      )
    )
  )
)

checkAssignedClientEditable = clientAuth.checkAsyncCondition (req, client, callback) ->
  Business.findById req.params.id, (error, business) ->
    callback null, business?.clientId is client.id and business.isClientEditable

isUserOrActiveAssignedClientEditor = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      clientAuth.checkActive
      auth.mwChainAnd(
        checkAssignedClientEditable
      )
    )
  )
)

isUserOrAssignedClient = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      checkAssignedClient
    )
  )
)

checkClientIdQuery = clientAuth.checkAsyncCondition (req, client, callback) ->
  callback null, req.query?.clientId is '' + client.id

isUserOrAssignedClientIdQuery = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      checkClientIdQuery
    )
  )
)



module.exports = express()
.use auth.authenticate

.get '/', isUserOrAssignedClientIdQuery, (req, res) ->
  Business.find(req.query).exec()
  .then (items) ->
    res.json items

.get '/distinct/:property', isUserOrAssignedClientIdQuery, (req, res, next) ->
  Business.distinct(req.params.property, req.query).exec()
  .then (items) ->
    res.json items

.post '/', isUser, (req, res, next) ->
  return next new Error 'JSON request body not given' unless req.body?

  new Business req.body
  .save (error, item) ->
    return next error if error
    res.json item

.get '/:id', isUserOrAssignedClient, (req, res, next) ->
  Business.findById req.params.id, (error, item) ->
    return next error if error
    res.json item

.put '/:id', isUserOrActiveAssignedClientEditor, (req, res, next) ->
  return next new Error 'JSON request body not given' unless req.body?
  req.body.clientId = null unless req.body.clientId?

  userRestrictedProps = [
    'id'
    '_id'
  ]

  clientRestrictedProps = [
    'id'
    '_id'
    'name'
    'locality'
    'serviceLevel'
    'serviceStartDate'
    'industry'
    'isClientEditable'
    'clientId'
  ]

  Business.findById req.params.id, (error, item) ->
    return next error if error

    restrictedProps = if req.user? then userRestrictedProps else clientRestrictedProps

    (
      item[key] = value unless key in restrictedProps
    ) for key, value of req.body

    item.save (error, result) ->
      return next error if error
      res.json result

.delete '/:id', isUser, (req, res, next) ->
  Business.findByIdAndRemove req.params.id, (error, item) ->
    return next error if error
    res.json item
