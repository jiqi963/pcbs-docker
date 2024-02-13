express = require 'express'

Gantt = require './Model'
auth = require '../../lib/authentication'

module.exports = express()

.use auth.authenticate
.use auth.isUser (user) ->
  user?

.get '/', (req, res) ->
  Gantt.find().exec()
  .then (items) ->
    res.json items[0]

.post '/', (req, res, next) ->
  return next new Error 'JSON request body not given' unless req.body?

  Gantt.find().exec()
  .then (items) ->
    item = items[0] or new Gantt()
    item.rows = req.body
    item.save (error, item) ->
      return next error if error
      res.json item
