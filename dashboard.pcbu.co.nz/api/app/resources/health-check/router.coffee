express = require 'express'

Client = require '../joomla-client/Model'

module.exports = express()
.get '/', (req, res) ->
  Client.healthCheck (_, results) ->
    if Object.values(results).some((result) -> result.error?)
      res.status(500).json(results)
    else
      res.json results
