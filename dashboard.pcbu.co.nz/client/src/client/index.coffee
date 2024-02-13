angular = require 'angular'
global._ = require 'lodash'
moment = require 'moment'
require 'restangular'

commonModule = require '../common'

module.exports = angular.module 'pcbu.client', [
  'restangular'
  commonModule.name
]

.controller 'ClientController', require './Controller'
.controller 'ClientCertificationGroupController', require './certification/group/Controller'
.controller 'ClientCertificationEditController', require './certification/edit/Controller'

.controller 'ClientSessionController', (
  $routeParams
  ClientNavFactory
  CurrentClientFactory
) ->
  nav = ClientNavFactory

  if CurrentClientFactory.isLoggedIn and CurrentClientFactory.get().userId is $routeParams.id
    return nav.index $routeParams.id

  else if $routeParams.id? and $routeParams.sessionId?
    return CurrentClientFactory.set $routeParams.id, $routeParams.sessionId, (error, isLoggedIn) ->
      return nav.index $routeParams.id if isLoggedIn
      nav.login()
  nav.login()

.config ($routeProvider) ->
  $routeProvider
  .when '/client/:id/:businessId/certification/group/:classification/:groupName', {
    templateUrl: 'certification/group/ng.html'
    controller: 'ClientCertificationGroupController'
  }
  .when '/client/:id/:businessId/certification/:certificationId/edit', {
    templateUrl: 'certification/edit/ng.html'
    controller: 'ClientCertificationEditController'
  }
  .when '/client/:id/:businessId/certification/new', {
    templateUrl: 'certification/edit/ng.html'
    controller: 'ClientCertificationEditController'
  }
  .when '/client/:id/', {
    templateUrl: 'business/item.ng.html'
    controller: 'ClientController'
  }
  .when '/client/:id/edit', {
    templateUrl: 'business/item-edit.ng.html'
    controller: 'ClientController'
  }
  .when '/client/:id/:sessionId', {
    templateUrl: 'business/item.ng.html'
    controller: 'ClientSessionController'
  }
  .when '/client', {
    templateUrl: 'business/item.ng.html'
    controller: 'ClientSessionController'
  }

.factory 'ClientNavFactory', ($location, $window, NavFactory, CurrentClientFactory) ->
  base = '/client'
  currentClient = CurrentClientFactory.get()

  {
    index: () ->
      NavFactory "#{base}/#{currentClient.userId}"
    edit: () ->
      NavFactory "#{base}/#{currentClient.userId}/edit"
    login: () ->
      protocolPorts = {
        http: 80
        https: 443
      }

      port = if $location.port() is protocolPorts[$location.protocol()] then '' else ':' + $location.port()
      r = $location.protocol() + '://' + $location.host() + port + '/client'
      return $window.location.href = "http://pcbu.co.nz/get-session?return=#{r}"
    logout: () ->
      $window.location.href = 'http://pcbu.co.nz/logout.html'
    joomla: () ->
      $window.location.href = 'http://pcbu.co.nz/your-dashboard'
    certificationGroup: (businessId, classification, groupName) ->
      NavFactory "#{base}/#{currentClient.userId}/#{businessId}/certification/group/#{classification}/#{groupName}"
    certificationEdit: (businessId, id) ->
      NavFactory "#{base}/#{currentClient.userId}/#{businessId}/certification/#{id}/edit"
    certificationAdd: (businessId, queryParams) ->
      NavFactory "#{base}/#{currentClient.userId}/#{businessId}/certification/new", queryParams

  }

.factory 'ClientFactory', (Restangular) ->
  Restangular.service 'client'

.factory 'CurrentClientFactory', require './CurrentClientFactory'
