express = require 'express'
bodyParser = require 'body-parser'
cors = require 'cors'
morgan = require 'morgan'

disableCache = require './disableCache'
user = require '../resources/user/router'
business = require '../resources/business/router'
certification = require '../resources/certification/router'
joomlaClient = require '../resources/joomla-client/router'
gantt = require '../resources/gantt/router'
healthCheck = require '../resources/health-check/router'

module.exports = express()
  .use morgan('combined')
  .use bodyParser.json()
  .use cors()
  .use disableCache
  .disable 'etag'
  .use '/user', user
  .use '/business', business
  .use '/certification', certification
  .use '/client', joomlaClient
  .use '/gantt', gantt
  .use '/health-check', healthCheck
  .use (err, req, res, next) ->
    console.error(err)
    return res.send 401, 'invalid token' if err.name is 'UnauthorizedError'
    next()
