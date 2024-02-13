angular = require 'angular'
global._ = require 'lodash'
require 'restangular'

commonModule = require '../common'

module.exports = angular.module 'pcbu.certification', [
  'restangular'
  commonModule.name
]

.config ($routeProvider) ->
  $routeProvider
  .when '/certification', {
    templateUrl: 'certification/list/ng.html'
    controller: 'CertificationListController'
  }
  .when '/certification/group/:classification/:groupName', {
    templateUrl: 'certification/group/ng.html'
    controller: 'CertificationGroupController'
  }
  .when '/business/:businessId/certification/new', {
    templateUrl: 'certification/edit/ng.html'
    controller: 'CertificationEditController'
  }
  .when '/business/:businessId/certification/group/:classification/:groupName', {
    templateUrl: 'certification/group/ng.html'
    controller: 'CertificationGroupController'
  }
  .when '/business/:businessId/certification/:id/edit', {
    templateUrl: 'certification/edit/ng.html'
    controller: 'CertificationEditController'
  }

.controller 'CertificationEditController', require './edit/Controller'
.controller 'CertificationListController', require './list/Controller'
.controller 'CertificationSummaryController', require './summary/Controller'
.controller 'CertificationGroupController', require './group/Controller'

.factory 'CertificationNavFactory', (NavFactory) ->
  businessBase = 'business'
  base = 'certification'

  {
    list: () ->
      NavFactory "/#{base}"
    one: (businessId, id) ->
      NavFactory "/#{businessBase}/#{businessId}/#{base}/#{id}"
    edit: (businessId, id) ->
      NavFactory "/#{businessBase}/#{businessId}/#{base}/#{id}/edit"
    add: (businessId, queryParams) ->
      NavFactory "/#{businessBase}/#{businessId}/#{base}/new", queryParams
    group: (businessId, classification, groupName) ->
      if businessId?
        NavFactory "/#{businessBase}/#{businessId}/#{base}/group/#{classification}/#{groupName}"
      else
        NavFactory "/#{base}/group/#{classification}/#{groupName}"
  }

.factory 'CertificationFactory', require './CertificationFactory'
.factory 'CertificationUrgencyFactory', require './UrgencyFactory'

.directive 'certificationSummary', require './summary/directive'
