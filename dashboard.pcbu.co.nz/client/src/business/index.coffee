angular = require 'angular'
global._ = require 'lodash'
moment = require 'moment'
require 'restangular'

commonModule = require '../common'
certificationModule = require '../certification'

module.exports = angular.module 'pcbu.business', [
  'restangular'
  commonModule.name
]

.controller 'BusinessListController', require './list/Controller'
.controller 'BusinessController', require './ItemController'

.config ($routeProvider) ->
  $routeProvider
  .when '/business', {
    templateUrl: 'business/list/ng.html'
    controller: 'BusinessListController'
  }
  .when '/business/new', {
    templateUrl: 'business/item-edit.ng.html'
    controller: 'BusinessController'
  }
  .when '/business/:id', {
    templateUrl: 'business/item.ng.html'
    controller: 'BusinessController'
  }
  .when '/business/:id/edit', {
    templateUrl: 'business/item-edit.ng.html'
    controller: 'BusinessController'
  }

.factory 'BusinessNavFactory', (NavFactory) ->
  base = '/business'

  {
    list: () ->
      NavFactory base
    one: (id) ->
      NavFactory "#{base}/#{id}"
    edit: (id) ->
      NavFactory "#{base}/#{id}/edit"
    add: () ->
      NavFactory "#{base}/new"
  }

.factory 'BusinessReviewFactory', () ->
  futureEndOfToday = moment().endOf 'day'
  year = futureEndOfToday.year()
  futureAnnualReviewDue = moment().add(28, 'days').endOf 'day'

  obj = {
    nextAnnualReviewDate: (business) ->
      return unless business?.serviceStartDate?

      annualReviewDate = moment(business.serviceStartDate).year year

      if annualReviewDate.isBefore futureEndOfToday
        annualReviewDate.year year + 1

      annualReviewDate.toDate()

    isAnnualReviewDue: (business) ->
      m = moment obj.nextAnnualReviewDate business
      m?.isBefore futureAnnualReviewDue
  }
  obj

.factory 'BusinessFactory', (Restangular) ->
  Restangular.service 'business'
