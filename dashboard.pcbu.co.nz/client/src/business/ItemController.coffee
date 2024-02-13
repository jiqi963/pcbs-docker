_ = require 'lodash'

`// @ngInject`
module.exports = (
  $scope
  $routeParams
  $modal
  BusinessFactory
  BusinessNavFactory
  FormValidationFactory
  BusinessReviewFactory
  CurrentUserFactory
  ClientFactory
) ->

  $scope.canEdit = () -> true
  $scope.canEditRestricted = () -> true

  nav = BusinessNavFactory

  $scope.fieldClass = FormValidationFactory

  $scope.nextAnnualReviewDate = BusinessReviewFactory.nextAnnualReviewDate
  $scope.isAnnualReviewDue = BusinessReviewFactory.isAnnualReviewDue

  if $routeParams.id?
    BusinessFactory.one $routeParams.id
      .get()
      .then (business) ->
        $scope.business = business
  else
    dateNow = new Date()
    $scope.business = {
      serviceLevel: 2
      serviceStartDate: dateNow.toISOString()
      contactPcbu: []
      contactOfficer: []
    }
    $scope.isNew = true

  # get distinct regions
  BusinessFactory.one('distinct')
    .customGETLIST 'locality.region'
    .then (regions) ->
      $scope.regions = _.sortBy regions, (s) ->
        s?.toLowerCase?()

  # get distinct industries
  BusinessFactory.one('distinct')
    .customGETLIST 'industry'
    .then (industries) ->
      $scope.industries = _.sortBy industries, (s) ->
        s?.toLowerCase?()

  # get distinct localities
  BusinessFactory.one('distinct')
    .customGETLIST 'locality'
    .then (localities) ->
      $scope.localities = _.sortBy localities, (s) ->
        s?.toLowerCase?()

  ClientFactory.getList()
    .then (clients) ->
      $scope.clients = [{name: 'None'}].concat _.sortBy clients, (c) ->
        c?.name?.toLowerCase?()

  $scope.contactTabs = [
    {active: true}
    {active: false}
  ]

  removeContact = (contactsArray, contact) ->
    i = _.indexOf contactsArray, contact
    if i > -1
      contactsArray.splice i, 1

  $scope.pcbu =
    contact: null
    original: null
    edit: (c) ->
      @contact = _.clone c
      @original = c
    cancel: () ->
      if $scope.itemForm.editContactPcbuForm.$dirty
        $modal.open {
          templateUrl: 'common/modal.ng.html'
          controller: ($scope) ->
            $scope.title = 'Un-saved contact'
            $scope.message = 'Are you sure you would like to discard un-saved changes?'
            $scope.options = [
              {
                text: 'Yes'
                action: () ->
                  $scope.$close true
              }
              {
                text: 'No'
                action: () ->
                  $scope.$close false
              }
            ]
        }
        .result.then (result) ->
          if result
            $scope.pcbu.edit null
      else
        @edit null
    delete: () ->
      $modal.open {
        templateUrl: 'common/modal.ng.html'
        controller: ($scope) ->
          $scope.title = 'Delete contact'
          $scope.message = 'Are you sure you would like to delete this contact?'
          $scope.options = [
            {
              text: 'Yes'
              action: () ->
                $scope.$close true
            }
            {
              text: 'No'
              action: () ->
                $scope.$close false
            }
          ]
      }
      .result.then (result) ->
        if result
          removeContact $scope.business.contactPcbu, $scope.pcbu.original
          $scope.pcbu.cancel()
    save: () ->
      if _.includes $scope.business.contactPcbu, @original
        _.assign @original, @contact
      else
        $scope.business.contactPcbu.push @contact
      @cancel()

  $scope.officer =
    contact: null
    original: null
    edit: (c) ->
      @contact = _.clone c
      @original = c
    cancel: () ->
      if $scope.itemForm.editContactOfficerForm.$dirty
        $modal.open {
          templateUrl: 'common/modal.ng.html'
          controller: ($scope) ->
            $scope.title = 'Un-saved contact'
            $scope.message = 'Are you sure you would like to discard un-saved changes?'
            $scope.options = [
              {
                text: 'Yes'
                action: () ->
                  $scope.$close true
              }
              {
                text: 'No'
                action: () ->
                  $scope.$close false
              }
            ]
        }
        .result.then (result) ->
          if result
            $scope.officer.edit null
      else
        @edit null
    delete: () ->
      $modal.open {
        templateUrl: 'common/modal.ng.html'
        controller: ($scope) ->
          $scope.title = 'Delete contact'
          $scope.message = 'Are you sure you would like to delete this contact?'
          $scope.options = [
            {
              text: 'Yes'
              action: () ->
                $scope.$close true
            }
            {
              text: 'No'
              action: () ->
                $scope.$close false
            }
          ]
      }
      .result.then (result) ->
        if result
          removeContact $scope.business.contactOfficer, $scope.officer.original
          $scope.officer.cancel()
    save: () ->
      if _.includes $scope.business.contactOfficer, @original
        _.assign @original, @contact
      else
        $scope.business.contactOfficer.push @contact
      @cancel()

  # fill the region from locality
  $scope.fillRegion = (selectedLocality) ->
    if selectedLocality.region?.length
      $scope.business.locality.region = selectedLocality.region

  $scope.isDatePickerOpen = false
  $scope.openDatePicker = ($event) ->
    $event.preventDefault()
    $event.stopPropagation()
    $scope.isDatePickerOpen = true

  $scope.edit = () ->
    nav.edit $scope.business._id

  $scope.save = () ->
    if $scope.isNew
      BusinessFactory.post $scope.business
        .then (business) ->
          nav.one business._id
    else
      $scope.business.save()
        .then () ->
          nav.one $routeParams.id

  $scope.delete = () ->
    unless $scope.isNew
      $modal.open {
        templateUrl: 'common/modal.ng.html'
        controller: ($scope) ->
          $scope.title = 'Delete business'
          $scope.message = 'Are you sure you would like to permanently delete this business?'
          $scope.options = [
            {
              text: 'Yes'
              action: () ->
                $scope.$close true
            }
            {
              text: 'No'
              action: () ->
                $scope.$close false
            }
          ]
      }
      .result.then (result) ->
        if result
          $scope.business.remove()
            .then () ->
              nav.list()

  $scope.cancel = () ->
    if $scope.itemForm.$dirty
      $modal.open {
        templateUrl: 'common/modal.ng.html'
        controller: ($scope) ->
          $scope.title = 'Un-saved business'
          $scope.message = 'Are you sure you would like to discard un-saved changes?'
          $scope.options = [
            {
              text: 'Yes'
              action: () ->
                $scope.$close true
            }
            {
              text: 'No'
              action: () ->
                $scope.$close false
            }
          ]
      }
      .result.then (result) ->
        $scope.navBack() if result

    else
      $scope.navBack()

  $scope.navBack = () ->
    if $scope.isNew
      $scope.navToAll()
    else
      nav.one $scope.business._id

  $scope.navToAll = nav.list
