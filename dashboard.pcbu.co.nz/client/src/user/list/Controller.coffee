`// @ngInject`
module.exports = (
  $scope
  UserFactory
  CurrentUserFactory
  UserNavFactory
) ->
  $scope.currentUser = CurrentUserFactory

  UserFactory.getList()
    .then (users) ->
      $scope.users = users

  $scope.addUser = UserNavFactory.add

  $scope.editUser = (user) ->
    if user?._id?
      UserNavFactory.edit user._id
