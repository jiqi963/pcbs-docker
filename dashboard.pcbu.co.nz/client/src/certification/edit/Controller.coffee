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
  FormValidationFactory
) ->
  certificationId = $routeParams.id
  businessId = $routeParams.businessId
  groupName = $routeParams.groupName
  classification = $routeParams.classification or 'person'

  businessNav = BusinessNavFactory
  certificationNav = CertificationNavFactory

  $scope.fieldClass = FormValidationFactory
  $scope.getUrgencyClass = CertificationUrgencyFactory.getClass

  $scope.canDelete = true

  $scope.classifications = {
    person:
      order: 0
      isNew: true
      label: 'Person'
      sortBy: (p) ->
        p.nameLast?.toLowerCase() + p.nameFirst?.toLowerCase()
      newFields: [
        {
          key: 'nameFirst'
          name: 'personNameFirst'
          id: 'certificationPersonNameFirst'
          label: 'First name'
          type: 'text'
          required: true
        }
        {
          key: 'nameLast'
          name: 'personNameLast'
          id: 'certificationPersonNameLast'
          label: 'Last name'
          type: 'text'
          required: true
        }
        {
          key: 'position'
          name: 'personPosition'
          id: 'certificationPersonPosition'
          label: 'Position'
          type: 'text'
        }
      ]
    equipment:
      order: 1
      isNew: true
      label: 'Equipment'
      sortBy: (p) ->
        p.description?.toLowerCase()
      newFields: [
        {
          key: 'description'
          name: 'equipmentDescription'
          id: 'certificationEquipmentDescription'
          label: 'Description'
          type: 'text'
          required: true
        }
      ]
    material:
      order: 2
      isNew: true
      label: 'Material/Environment'
      sortBy: (p) ->
        p.description?.toLowerCase()
      newFields: [
        {
          key: 'description'
          name: 'materialDescription'
          id: 'certificationMaterialDescription'
          label: 'Description'
          type: 'text'
          required: true
        }
      ]
    vehicle:
      order: 3
      isNew: true
      label: 'Vehicle'
      sortBy: (v) ->
        v.make?.toLowerCase() + v.model?.toLowerCase()
      newFields: [
        {
          key: 'make'
          name: 'vehicleMake'
          id: 'certificationVehicleMake'
          label: 'Make'
          type: 'text'
          required: true
        }
        {
          key: 'model'
          name: 'vehicleModel'
          id: 'certificationVehicleModel'
          label: 'Model'
          type: 'text'
          required: true
        }
        {
          key: 'registration'
          name: 'vehicleRegistration'
          id: 'certificationVehicleRegistration'
          label: 'Registration'
          type: 'text'
          required: true
        }
      ]
  }

  $scope.classificationsArray = _.map $scope.classifications, (v, k) ->
    {
      key: k
      classification: v
    }

  $scope.isNewName = false

  $scope.distinct = {
    name: {}
  }

  # get distinct certification names for given classification
  populateDistinctNames = (classification) ->
    CertificationFactory.one('distinct')
      .customGETLIST 'name', {classification: classification}
      .then (items) ->
        $scope.distinct.name[classification] = _.sortBy items, (name) ->
          name?.toLowerCase()

  # get distinct certification things for given classification -- specific to this business
  populateDistinctThings = (classification, sortFn) ->
    CertificationFactory.one('distinct')
      .customGETLIST classification, {business: businessId}
      .then (items) ->
        $scope.distinct[classification] = _.sortBy items, $scope.classifications[classification].sortBy

  init = () ->
    # get the business
    BusinessFactory.one businessId
      .get()
      .then (business) ->
        $scope.business = business

    # get the existing certification or create a new object
    if certificationId?
      CertificationFactory.one certificationId
        .get()
        .then (certification) ->
          $scope.certification = certification
          populateDistinctNames certification.classification
          populateDistinctThings certification.classification
    else
      dateNow = new Date()

      $scope.certification = {
        name: groupName
        business: businessId
        date: dateNow.toISOString()
        expiryDate: dateNow.toISOString()
        classification: classification
        isNew: true
      }

      (
        populateDistinctNames k
        populateDistinctThings k
      ) for k, v of $scope.classifications

  init()

  ((classification, value) ->
    $scope.$watch "classifications.#{classification}.isNew", (now, was) ->
      $scope.certification?[classification] = {} if now isnt was
  )(k, v) for k, v of $scope.classifications

  $scope.$watch 'certification.classification', (now, was) ->
    if now? and was? and now isnt was
      $scope.certification.name = ''
      $scope.certification[now] = {}


  $scope.$watch 'isNewName', (now, was) ->
    if now isnt was
      $scope.certification.name = ''


  $scope.edit = () ->
    certificationNav.edit $scope.certification._id

  $scope.save = () ->
    if $scope.certification?.isNew
      CertificationFactory.post $scope.certification
        .then (certification) ->
          $scope.navBack()
    else
      $scope.certification.save()
        .then () ->
          $scope.navBack()

  $scope.delete = () ->
    unless $scope.certification?.isNew
      $modal.open {
        templateUrl: 'common/modal.ng.html'
        controller: ($scope) ->
          $scope.title = 'Delete certification'
          $scope.message = 'Are you sure you would like to permanently delete this certification?'
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
          $scope.certification.remove()
            .then () ->
              $scope.navBack()

  $scope.cancel = () ->
    if $scope.itemForm.$dirty
      $modal.open {
        templateUrl: 'common/modal.ng.html'
        controller: ($scope) ->
          $scope.title = 'Un-saved changes'
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
    businessNav.one $scope.business._id
