config = require 'config'
mongoose = require 'mongoose'
server = require './lib/server'

port = config.get 'server.port'

mongoose.connect config.get 'mongodb'

mongoose.connection
.on 'error', () ->
  console.error 'MongoDB connection error'
.once 'open', () ->
  server.listen port, () ->
    console.log "API server listening on port #{port}"
