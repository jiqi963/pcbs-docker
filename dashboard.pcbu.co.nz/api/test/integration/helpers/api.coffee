supertest = require 'supertest'
server = require '../../../app/lib/server'

module.exports = supertest.agent server
