_ = require 'lodash'
moment = require 'moment'

`// @ngInject`
module.exports = (
  $scope
  $routeParams
  $modal
  BusinessFactory
  CertificationFactory
  BusinessNavFactory
  CertificationNavFactory
  CertificationUrgencyFactory
  CurrentUserFactory
  ClientNavFactory
  CurrentClientFactory
) ->

  businessNav = BusinessNavFactory
  certificationNav = BusinessNavFactory

  $scope.businessId = $routeParams.businessId
  $scope.classification = $routeParams.classification
  $scope.groupName = $routeParams.groupName

  $scope.hasEditRight = () ->
    $scope.business?.isClientEditable and
    $scope.business?.clientId is parseInt CurrentClientFactory.get().userId

  if $scope.businessId
    BusinessFactory.one $scope.businessId
      .get()
      .then (business) ->
        $scope.business = business
  else
    ClientNavFactory.index()

  setCertifications = (certifications) ->
    $scope.certifications = certifications

    $scope.certificationsByUrgency = _(certifications)
      .sortBy (c) ->
        return unless c.expiryDate?
        moment(c.expiryDate).valueOf()
      .groupBy (c) ->
        d = if c.expiryDate? then new Date c.expiryDate else null
        switch
          when d is null
            'notDue'
          when CertificationUrgencyFactory.isDue d
            'due'
          when CertificationUrgencyFactory.isDueSoon d
            'dueSoon'
          else 'notDue'
      .value()

  certQuery = {}
  certQuery.business = $scope.businessId if $scope.businessId?
  certQuery.name = $scope.groupName if $scope.groupName?

  CertificationFactory.getList certQuery
  .then setCertifications

  $scope.navBack = ClientNavFactory.index

  $scope.addCertification = () ->
    if $scope.businessId
      ClientNavFactory.certificationAdd $scope.businessId, {
        groupName: $scope.groupName
        classification: $scope.classification
      }

  $scope.update = (certification) ->
    return unless certification?._id? and certification?.business?

    ClientNavFactory.certificationEdit certification.business, certification._id, {
      groupName: $scope.groupName
      classification: $scope.classification
    }

  $scope.days = {
    due: CertificationUrgencyFactory.daysDue
    dueSoon: CertificationUrgencyFactory.daysDueSoon
  }
  $scope.getUrgencyClass = CertificationUrgencyFactory.getClass
