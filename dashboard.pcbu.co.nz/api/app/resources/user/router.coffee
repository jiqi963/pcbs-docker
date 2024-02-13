express = require 'express'

User = require './Model'
auth = require '../../lib/authentication'

isUserAdmin = (req, res, next) ->
  return next() if req.user.isAdmin
  res.sendStatus 400

isUserAdminOrSelf = (req, res, next) ->
  return next() if req.user.isAdmin
  return next() if req.user._id is req.params.id
  res.sendStatus 400

module.exports = express()

.get '/', auth.authenticate, isUserAdmin, (req, res) ->
  User.find req.query
  .select '-password'
  .exec()
  .then (items) ->
    res.json items

.post '/', auth.authenticate, isUserAdmin, (req, res, next) ->
  return next new Error 'JSON request body not given' unless req.body?

  new User req.body
  .save (error, item) ->
    return next error if error
    res.json item

.post '/sign-in', (req, res, next) ->
  return next() unless req.body?.username? and req.body?.password?

  User.findOne {username: req.body.username}, (error, user) ->
    return next() if error
    return next() unless user

    user.isValidPassword req.body.password, (error, isMatch) ->
      return next() unless isMatch

      token = auth.signUser user

      res.json {
        user: user
        token: token
      }

.get '/:id', auth.authenticate, isUserAdminOrSelf, (req, res, next) ->
  User.findById req.params.id, (error, item) ->
    return next error if error
    res.json item

.put '/:id', auth.authenticate, isUserAdminOrSelf, (req, res, next) ->
  return next new Error 'JSON request body not given' unless req.body?

  User.findById req.params.id, (error, item) ->
    return next error if error

    (
      item[key] = value
    ) for key, value of req.body

    item.save (error, item) ->
      return next error if error
      res.json item

.delete '/:id', auth.authenticate, isUserAdmin, (req, res, next) ->
  User.findByIdAndRemove req.params.id, (error, item) ->
    return next error if error
    res.json item
