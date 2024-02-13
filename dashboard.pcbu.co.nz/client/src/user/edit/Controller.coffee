`// @ngInject`
module.exports = (
  $scope
  $routeParams
  $modal
  UserFactory
  CurrentUserFactory
  UserNavFactory
  FormValidationFactory
) ->
  $scope.currentUser = CurrentUserFactory
  $scope.fieldClass = FormValidationFactory
  $scope.navBack = UserNavFactory.list

  $scope.changePassword = false

  if $routeParams.id?
    UserFactory.one $routeParams.id
      .get()
      .then (user) ->
        $scope.user = user
        $scope.user.isCurrent = user._id is $scope.currentUser.user._id
  else
    $scope.user = {
      isAdmin: false
      isNew: true
    }

  $scope.save = () ->
    if $scope.user.isNew
      UserFactory.post $scope.user
        .then (user) ->
          $scope.navBack()
    else
      $scope.user.save()
        .then () ->
          if $scope.user.isCurrent
            $scope.currentUser.refresh()
          $scope.navBack()

  $scope.delete = () ->
    unless $scope.user.isNew or $scope.user.isCurrent
      $modal.open {
        templateUrl: 'common/modal.ng.html'
        controller: ($scope) ->
          $scope.title = 'Delete user'
          $scope.message = 'Are you sure you would like to permanently delete this user?'
          $scope.options = [
            {
              text: 'Yes'
              action: () ->
                $scope.$close true
            }
            {
              text: 'No'
              action: () ->
                $scope.$close false
            }
          ]
      }
      .result.then (result) ->
        if result
          $scope.user.remove()
            .then () ->
              $scope.navBack()

  $scope.cancel = () ->
    if $scope.itemForm.$dirty
      $modal.open {
        templateUrl: 'common/modal.ng.html'
        controller: ($scope) ->
          $scope.title = 'Un-saved user'
          $scope.message = 'Are you sure you would like to discard un-saved changes?'
          $scope.options = [
            {
              text: 'Yes'
              action: () ->
                $scope.$close true
            }
            {
              text: 'No'
              action: () ->
                $scope.$close false
            }
          ]
      }
      .result.then (result) ->
        $scope.navBack() if result

    else
      $scope.navBack()
