_ = require 'lodash'

`// @ngInject`
module.exports = (
  $scope
  $routeParams
  $modal
  ClientFactory
  ClientNavFactory
  CurrentClientFactory
  BusinessFactory
) ->

  nav = ClientNavFactory
  $scope.toJoomla = nav.joomla

  if CurrentClientFactory.isLoggedIn() and '' + CurrentClientFactory.get().userId is $routeParams.id
    ClientFactory.one $routeParams.id
      .get()
      .then (client) ->
        $scope.client = client
      .catch (error) ->
        nav.login()

    # get the business
    BusinessFactory.getList {clientId: $routeParams.id}
      .then (businesses) ->
        $scope.business = businesses[0]

  else
    nav.login()

  $scope.canEdit = () ->
    CurrentClientFactory.isLoggedIn() && $scope.business?.isClientEditable

  $scope.canEditRestricted = () -> false

  $scope.isClient = () ->
    $scope.business?.clientId is $scope.client?.id
