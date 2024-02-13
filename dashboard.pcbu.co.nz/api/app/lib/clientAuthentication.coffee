Client = require '../resources/joomla-client/Model'

checkLoggedIn = (req, callback) ->
  userId = req.get 'joomla-user-id'
  sessionId = req.get 'joomla-session-id'
  Client.isLoggedIn userId, sessionId, callback

checkActive = (req, callback) ->
  userId = req.get 'joomla-user-id'
  Client.isActive userId, callback

module.exports =
  checkLoggedIn: (req, callback) ->
    checkLoggedIn req, (error, item) ->
      callback error, item?.isLoggedIn

  checkActive: (req, callback) ->
    checkActive req, (error, result) ->
      callback error, result

  checkAsyncCondition: (conditionFn) ->
    (req, callback) ->
      checkLoggedIn req, (error, item) ->
        conditionFn req, item, callback
