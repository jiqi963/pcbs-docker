`// @ngInject`
module.exports = (
  $scope
  BusinessNavFactory
) ->
  $scope.navToBusinesses = BusinessNavFactory.list
