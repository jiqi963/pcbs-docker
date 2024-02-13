config = require 'config'
mongoose = require 'mongoose'
minimist = require 'minimist'
User = require './app/resources/user/Model'

args = minimist(process.argv.slice 2)._

mongoose.connect config.mongodb

if config.has 'mongodb'
  mongoose.connection
  .on 'error', () ->
    console.error 'MongoDB connection error'
  .once 'open', () ->
    # count existing admin users
    User.count {isAdmin: true}, (error, n) ->
      if n > 0
        console.log "Initial admin user already exists"
        return mongoose.connection.close()

      # create new admin user with given arguments
      new User {
        username: args[0]
        nameFirst: args[1]
        nameLast: args[2]
        password: args[3]
        isAdmin: true
      }
      .save (error, user) ->
        if error
          console.log error
        else
          console.log "Created initial admin user: #{user}"
        mongoose.connection.close()
