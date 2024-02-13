angular = require 'angular'

module.exports = angular.module 'pcbu.common', []

.directive 'contentBar', require './contentBar/directive'

.factory 'FormValidationFactory', require './FormValidationFactory'

.factory 'NavFactory', ($location) ->
  (path, queryParams) ->
    # set path and clear existing search parameters
    $location.url path

    # set search parameters
    (
      $location.search k, v
    ) for k, v of queryParams
