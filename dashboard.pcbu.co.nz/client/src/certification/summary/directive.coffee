module.exports = () ->
  {
    scope:
      business: '='
      textSearch: '='
      all: '&'
    templateUrl: 'certification/summary/ng.html'
    restrict: 'E'
    controller: 'CertificationSummaryController'
  }
