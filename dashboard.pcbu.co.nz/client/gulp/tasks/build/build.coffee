gulp = require 'gulp'

gulp.task 'build', [
  'build:html'
  'build:js'
  'build:angularTemplates'
  'build:styles'
]

gulp.task 'production:build', [
  'production:build:html'
  'production:build:js'
  'production:build:angularTemplates'
  'production:build:styles'
]
