_ = require 'lodash'
moment = require 'moment'

`// @ngInject`
module.exports = (
  $scope
  $rootScope
  CertificationFactory
  BusinessFactory
  CertificationNavFactory
  CertificationUrgencyFactory
  CurrentUserFactory
  ClientNavFactory
  CurrentClientFactory
) ->

  # Are we viewing the owner of the certification?
  $scope.viewHolder = false

  $scope.currentUser = CurrentUserFactory
  currentClient = CurrentClientFactory.get()

  $scope.hasEditRight = () ->
    $scope.currentUser?.user or $scope.business?.isClientEditable

  $scope.tabs = [
    {
      heading: 'Personel'
      classification: 'person'
      isActive: true
    }
    {
      heading: 'Equipment'
      classification: 'equipment'
      isActive: false
    }
    {
      heading: 'Materials/Environment'
      classification: 'material'
      isActive: false
    }
    {
      heading: 'Vehicles'
      classification: 'vehicle'
      isActive: false
    }
  ]

  setCertifications = (certifications) ->
    $scope.certifications = certifications

    $scope.certificationGroups = _ certifications
      .groupBy('classification')
      .mapValues((v) ->
        _ v
          .sortBy (c) ->
            return unless c.expiryDate?
            moment(c.expiryDate).valueOf()
          .groupBy 'name'
          .map((g, name) ->
            urgency = _.groupBy g, (c) ->
              d = if c.expiryDate? then new Date c.expiryDate else null
              switch
                when d is null
                  'notDue'
                when CertificationUrgencyFactory.isDue d
                  'due'
                when CertificationUrgencyFactory.isDueSoon d
                  'dueSoon'
                else 'notDue'

            {
              name: name
              certifications: g
              urgency: urgency
            }
          )
          .value()
      )
      .value()

    # Lets store our new holders in here
    $scope.holderObjects = []

    # Group the certification holders
    $scope.certificationHolderGroups = _ certifications
      .groupBy('classification')
      .mapValues((v) ->
        _ v
          .map((g, name) ->

            # Default name
            objectDescription = 'Holder'

            # Let's create custom descriptions/names
            if g.classification is 'person'
              objectDescription = g[g.classification]['nameFirst'] + ' ' + g[g.classification]['nameLast']
            else if g.classification is 'vehicle'
              objectDescription = g[g.classification]['make'] + ' ' + g[g.classification]['model'] + ' (' + g[g.classification]['registration'] + ')'
            else
              objectDescription = g[g.classification]['description']

            # Add it to the holderObjects array
            # Does the array of objects contain this description/name?
            contains = false
            for i in $scope.holderObjects
              if i.name is objectDescription
                # Add a new certification to this object
                i.certifications.push(g)
                contains = true
                break
            # If this is a new person
            if not contains
              newHolderObj = {
                name: objectDescription,
                classification: g.classification
                certifications: [g]
              }

              newHolderObj[g.classification] = g[g.classification]

              $scope.holderObjects.push newHolderObj

          )
          .value()
      )
      .value()


  getForBusiness = (business) ->
    CertificationFactory.getList {
      business: $scope.business._id
    }, $rootScope.joomlaClientRequestHeaders
    .then setCertifications

  getForAll = () ->
    CertificationFactory.getList()
    .then setCertifications

  if $scope.all()
    getForAll()
    BusinessFactory.getList()
    .then (businesses) ->
      $scope.businesses = _.indexBy businesses, '_id'
  else
    $scope.$watch 'business', () ->
      if $scope.business?._id?
        getForBusiness $scope.business

  $scope.daysDue = CertificationUrgencyFactory.daysDue
  $scope.daysDueSoon = CertificationUrgencyFactory.daysDueSoon
  $scope.getUrgencyClass = CertificationUrgencyFactory.getClass

  $scope.groupSearchFilter = (group) ->
    return unless group?

    # properties to search
    values = _.compact [
      group.name
    ]

    target = $scope.textSearch?.toLowerCase()

    return true unless target

    _.some values, (v) ->
      v?.toString().toLowerCase().indexOf(target) >= 0

  $scope.getGroupOrder = (group) ->
    CertificationUrgencyFactory.getOrder(
      group?.urgency?.due?.length
      group?.urgency?.dueSoon?.length
    )

  $scope.navigateToGroup = (group) ->
    if group?.name?
      classification = _.find($scope.tabs, 'isActive')?.classification
      if classification?
        if parseInt(currentClient.userId) is $scope.business?.clientId
          return ClientNavFactory.certificationGroup(
            $scope.business?._id
            classification
            group.name
          )
        CertificationNavFactory.group $scope.business?._id, classification, group.name

  $scope.addCertification = () ->
    if $scope.business?._id?
      classification = _.find($scope.tabs, 'isActive')?.classification

      if currentClient.userId is $scope.business.clientId
        ClientNavFactory.certificationAdd $scope.business._id, {
          classification: classification
        }
      else
        CertificationNavFactory.add $scope.business._id, {
          classification: classification
        }

  $scope.update = (certification) ->
    return unless certification?._id? and certification?.business?

    CertificationNavFactory.edit certification.business, certification._id, {
      groupName: certification.name
      classification: certification.classification
    }

  # Switch from certification view to certification owner view and vice versa
  $scope.switchView = () ->
    $scope.viewHolder = not $scope.viewHolder
