express = require 'express'

Certification = require './Model'
Business = require '../business/Model'
auth = require '../../lib/authentication'
clientAuth = require '../../lib/clientAuthentication'

userCheck = (req, callback) ->
  callback null, req.user?

adminUserCheck = (req, callback) ->
  callback null, req.user?.isAdmin

# Authorization Middleware

isUser = auth.mwChainOr userCheck
isAdminUser = auth.mwChainOr adminUserCheck

isUserOrActiveClient = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      clientAuth.checkActive
    )
  )
)

checkBusinessQueryAssignedClient = clientAuth.checkAsyncCondition (req, client, callback) ->
  return callback null, false unless req.query.business?

  Business.findById req.query.business, (error, business) ->
    callback null, business?.clientId is client.id

checkBusinessBodyAssignedClientEditor = clientAuth.checkAsyncCondition (req, client, callback) ->
  return callback null, false unless req.body?.business?

  Business.findById req.body?.business, (error, business) ->
    callback null, business?.clientId is client.id and business.isClientEditable

isUserOrClientViewOwn = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      clientAuth.checkActive
      auth.mwChainAnd(
        checkBusinessQueryAssignedClient
      )
    )
  )
)

isUserOrClientViewEditOwn = auth.mwChainOr(
  userCheck
  auth.mwChainAnd(
    clientAuth.checkLoggedIn
    auth.mwChainAnd(
      clientAuth.checkActive
      auth.mwChainAnd(
        checkBusinessBodyAssignedClientEditor
      )
    )
  )
)


# checkAssignedClientEditable = clientAuth.checkAsyncCondition (req, client, callback) ->
#   Business.findById req.params.id, (error, business) ->
#     callback null, business?.clientId is client.id and business.isClientEditable
#
# isUserOrActiveAssignedClientEditor = auth.mwChainOr(
#   userCheck
#   auth.mwChainAnd(
#     clientAuth.checkLoggedIn
#     auth.mwChainAnd(
#       clientAuth.checkActive
#       auth.mwChainAnd(
#         checkAssignedClientEditable
#       )
#     )
#   )
# )
#
# isUserOrAssignedClient = auth.mwChainOr(
#   userCheck
#   auth.mwChainAnd(
#     clientAuth.checkLoggedIn
#     auth.mwChainAnd(
#       checkAssignedClient
#     )
#   )
# )
#
# checkClientIdQuery = clientAuth.checkAsyncCondition (req, client, callback) ->
#   callback null, req.query?.clientId is '' + client.id
#
# isUserOrAssignedClientIdQuery = auth.mwChainOr(
#   userCheck
#   auth.mwChainAnd(
#     clientAuth.checkLoggedIn
#     auth.mwChainAnd(
#       checkClientIdQuery
#     )
#   )
# )

module.exports = express()
.use auth.authenticate

.get '/', isUserOrClientViewOwn, (req, res, next) ->
  Certification.find(req.query).exec()
  .then (items) ->
    res.json items

.post '/', isUserOrClientViewEditOwn, (req, res, next) ->
  return next new Error 'JSON request body not given' unless req.body?

  new Certification req.body
  .save (error, item) ->
    return next error if error
    res.json item

.get '/distinct/:property', isUserOrClientViewOwn, (req, res, next) ->
  Certification.distinct(req.params.property, req.query).exec()
  .then (items) ->
    res.json items

.get '/:id', (req, res, next) ->
  Certification.findById req.params.id, (error, item) ->
    return next error if error
    res.json item

.put '/:id', isUserOrClientViewEditOwn, (req, res, next) ->
  return next new Error 'JSON request body not given' unless req.body?

  Certification.findById req.params.id, (error, item) ->
    return next error if error

    (
      item[key] = value
    ) for key, value of req.body

    item.save (error, item) ->
      return next error if error
      res.json item

.delete '/:id', isUser, (req, res, next) ->
  Certification.findByIdAndRemove req.params.id, (error, item) ->
    return next error if error
    res.json item
