angular = require 'angular'
global._ = require 'lodash'
require 'restangular'
require 'ngstorage'

commonModule = require '../common'

module.exports = angular.module 'pcbu.user', [
  'restangular'
  'ngStorage'
  commonModule.name
]

.controller 'UserController', require './Controller'
.controller 'UserListController', require './list/Controller'
.controller 'UserEditController', require './edit/Controller'
.controller 'UserSignInController', require './signIn/Controller'

.factory 'UserFactory', require './UserFactory'
.factory 'CurrentUserFactory', require './CurrentUserFactory'

.factory 'UserNavFactory', (NavFactory) ->
  base = '/user'
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

.factory 'CurrentUserNavFactory', (NavFactory) ->
  {
    signIn: () ->
      NavFactory '/sign-in'
  }

.config ($routeProvider) ->
  $routeProvider
  .when '/sign-in', {
    templateUrl: 'user/signIn/ng.html'
    controller: 'UserSignInController'
  }
  .when '/user', {
    templateUrl: 'user/list/ng.html'
    controller: 'UserListController'
  }
  .when '/user/new', {
    templateUrl: 'user/edit/ng.html'
    controller: 'UserEditController'
  }
  .when '/user/:id/edit', {
    templateUrl: 'user/edit/ng.html'
    controller: 'UserEditController'
  }

.run ($location, CurrentUserFactory, CurrentUserNavFactory) ->
  return if /^\/client/.test $location.path()

  # redirect to sign in path if user is not signed in and not at sign in path
  unless CurrentUserFactory.user? and CurrentUserFactory.token?
    CurrentUserNavFactory.signIn()

.run ($rootScope, $location, CurrentUserFactory, NavFactory) ->
  isPathEditSelf = (path) ->
    path is "/user/#{CurrentUserFactory.user._id}/edit"

  $rootScope.$on '$routeChangeStart', (event, next) ->
    path = $location.path()
    return unless /^\/user/.test path

    unless CurrentUserFactory.user?.isAdmin or isPathEditSelf path
      NavFactory '/'
