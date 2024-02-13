_ = require 'lodash'

`// @ngInject`
module.exports = (
  $scope
  BusinessFactory
  BusinessNavFactory
  CertificationFactory
  CertificationNavFactory
  CertificationUrgencyFactory
  BusinessReviewFactory
) ->

  $scope.navToCertifications = CertificationNavFactory.list

  nav = BusinessNavFactory

  BusinessFactory.getList()
    .then (businesses) ->
      $scope.businessList = businesses

  $scope.nextAnnualReviewDate = BusinessReviewFactory.nextAnnualReviewDate
  $scope.isAnnualReviewDue = BusinessReviewFactory.isAnnualReviewDue

  CertificationFactory.getList()
    .then (certifications) ->
      $scope.certsByBusiness = _(certifications)
        .groupBy('business')
        .mapValues((certs, business) ->
          _.groupBy certs, (c) ->
            d = if c.expiryDate? then new Date c.expiryDate else null
            switch
              when d is null
                'notDue'
              when CertificationUrgencyFactory.isDue d
                'due'
              when CertificationUrgencyFactory.isDueSoon d
                'dueSoon'
              else 'notDue'
        )
        .value()

  $scope.daysDue = CertificationUrgencyFactory.daysDue
  $scope.daysDueSoon = CertificationUrgencyFactory.daysDueSoon
  $scope.getUrgencyClass = CertificationUrgencyFactory.getClass

  $scope.getUrgency = (business) ->
    $scope.certsByBusiness?[business._id] if business?._id?

  $scope.getBusinessOrder = (business) ->
    urgency = $scope.getUrgency business
    reviewDue = $scope.isAnnualReviewDue business
    CertificationUrgencyFactory.getOrder (if reviewDue then 1 else 0) + (urgency?.due?.length or 0), (urgency?.dueSoon?.length or 0)

  $scope.businessSearchFilter = (business) ->
    return unless business?

    # properties to search
    values = _.compact [
      business.name
      business.locality?.name
      business.locality?.region
    ].concat business.industry

    target = $scope.textSearch?.toLowerCase()

    return true unless target

    _.some values, (v) ->
      v?.toString().toLowerCase().indexOf(target) >= 0

  $scope.heading = 'All businesses'

  $scope.addBusiness = nav.add

  $scope.navToBusiness = (id) ->
    nav.one id
