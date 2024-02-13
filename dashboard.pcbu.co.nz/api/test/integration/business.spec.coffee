api = require './helpers/api'
should = require('chai').should()

describe 'business', () ->

  it 'GET /business/', (done) ->
    api.get '/business/'
      .expect 200
      .expect 'Content-Type', /json/
      .end (err, res) ->
        return done err if err
        res.body.should.be.an.instanceof Array
        done()

  it 'GET /business/:id', (done) ->
    api.get '/business/0'
      .expect 200
      .expect 'Content-Type', /json/
      .end (err, res) ->
        return done err if err
        res.body.should.be.an 'object'
        done()
