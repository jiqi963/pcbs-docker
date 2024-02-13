_ = require 'lodash'
angular = require 'angular'
require 'angular-route'# ngRoute
require 'angular-sanitize'# ngSanitize
require 'angular-bootstrap' # ui.bootstrap
require 'angular-ui-utils/modules/validate/validate' # ui.validate
require 'angular-ui-utils/modules/inflector/inflector' # ui.inflector
require 'ngstorage' # ngStorage
require 'ui-select' # ui.select
global._ = require 'lodash' # grrrr!
require 'restangular'

businessModule = require './business'
certificationModule = require './certification'
userModule = require './user'
clientModule = require './client'

angular.module 'pcbu', [
  'ngRoute'
  'ngSanitize'
  'ngStorage'
  'ui.validate'
  'ui.inflector'
  'ui.bootstrap'
  'ui.select'
  'templates'
  businessModule.name
  certificationModule.name
  userModule.name
  clientModule.name
]

.config ($routeProvider, $locationProvider, $httpProvider) ->
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
  $routeProvider.otherwise {redirectTo: '/business'}
  $locationProvider.html5Mode true

.config (RestangularProvider) ->
  # TODO: get base url from configuration
  RestangularProvider.setBaseUrl window.pcbuApiUrl

  # use MongoDB id
  RestangularProvider.setRestangularFields {
    id: '_id'
  }

.run (Restangular, CurrentUserFactory, CurrentClientFactory) ->
  # add JSON Web Token and Joomla client data to request headers
  Restangular.addFullRequestInterceptor (
    element
    operation
    route
    url
    headers
    params
    httpConfig
  ) ->
    {
      element: element
      params: params
      headers: _.extend headers, {
        Authorization: 'Bearer ' + CurrentUserFactory.token
        'joomla-user-id': CurrentClientFactory.joomlaUserId
        'joomla-session-id': CurrentClientFactory.joomlaSessionId
      }
      httpConfig: httpConfig
    }

.config (uiSelectConfig) ->
  uiSelectConfig.theme = 'bootstrap'

.run ($rootScope, $location) ->
  $rootScope.go = (path) ->
    $location.path path
