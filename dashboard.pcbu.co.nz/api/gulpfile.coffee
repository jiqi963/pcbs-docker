gulp = require 'gulp'
mocha = require 'gulp-mocha'

gulp.task 'test:integration', () ->
  gulp.src './test/integration/**/*.spec.coffee'
    .pipe mocha()

gulp.task 'test', ['test:integration']
