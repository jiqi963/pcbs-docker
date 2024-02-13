`// @ngInject`
module.exports = (
  $scope
  CurrentUserFactory
  CurrentUserNavFactory
  UserNavFactory
  CurrentClientFactory
  ClientNavFactory
) ->
  $scope.currentUser = CurrentUserFactory
  $scope.clientIsLoggedIn = CurrentClientFactory.isLoggedIn()
  $scope.toJoomla = ClientNavFactory.joomla

  $scope.isNavCollapsed = true

  $scope.signOut = () ->
    CurrentUserFactory.signOut()
    CurrentUserNavFactory.signIn()

  $scope.editCurrentUser = () ->
    if CurrentUserFactory.user?._id?
      UserNavFactory.edit CurrentUserFactory.user._id
