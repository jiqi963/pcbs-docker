`// @ngInject`
module.exports = ($sessionStorage, $q, ClientFactory, CurrentUserFactory) ->
  obj = {
    set: (joomlaUserId, joomlaSessionId, callback) ->
      CurrentUserFactory.signOut()

      ClientFactory.one joomlaUserId
      .customGET "check-session/#{joomlaSessionId}"
      .then (result) ->
        if result?.isLoggedIn
          obj.joomlaUserId = parseInt joomlaUserId
          obj.joomlaSessionId = joomlaSessionId
          $sessionStorage.joomlaUserId = parseInt joomlaUserId
          $sessionStorage.joomlaSessionId = joomlaSessionId
        else
          obj.joomlaUserId = null
          obj.joomlaSessionId = null
          $sessionStorage.joomlaUserId = null
          $sessionStorage.joomlaSessionId = null

        callback null, obj.isLoggedIn()

    isLoggedIn: () ->
      obj.joomlaUserId? and obj.joomlaSessionId?

    get: () ->
      {
        userId: parseInt $sessionStorage.joomlaUserId
        sessionId: $sessionStorage.joomlaSessionId
      }

    joomlaUserId: $sessionStorage.joomlaUserId
    joomlaSessionId: $sessionStorage.joomlaSessionId
  }

  obj
