module.exports = () ->
  {
    templateUrl: 'common/contentBar/ng.html'
    restrict: 'E'
    scope:
      back: '='
      backAction: '='
      heading: '='
      extra: '='
      extraAction: '='
  }
