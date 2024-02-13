`// @ngInject`
module.exports = ($localStorage, $q, UserFactory) ->
  obj = {
    signIn: (username, password) ->
      UserFactory.one().customPOST {
        username: username
        password: password
      }, 'sign-in'
      .then (result) ->
        $localStorage.user = result.user
        $localStorage.token = result.token

        obj.user = $localStorage.user
        obj.token = $localStorage.token

    signOut: () ->
      $localStorage.$reset()
      obj.user = $localStorage.user
      obj.token = $localStorage.token

    refresh: () ->
      if obj.user?
        UserFactory.one obj.user._id
          .get()
          .then (user) ->
            $localStorage.user = user
            obj.user = $localStorage.user

    user: $localStorage.user
    token: $localStorage.token
  }

  obj
