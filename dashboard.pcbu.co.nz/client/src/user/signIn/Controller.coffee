`// @ngInject`
module.exports = (
  $scope
  CurrentUserFactory
  NavFactory
) ->
  return NavFactory '/' if CurrentUserFactory.user

  $scope.signIn = () ->
    CurrentUserFactory.signIn($scope.username, $scope.password).then () ->
      NavFactory '/'
