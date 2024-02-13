gulp = require 'gulp'
coffeelint = require 'gulp-coffeelint'

config = require '../../config'
coffeeLintConfig = require '../../config/coffeelint'

gulp.task 'lint:coffee', () ->
  gulp.src config.source.coffeeScripts
    .pipe coffeelint null, coffeeLintConfig
    .pipe coffeelint.reporter()
    .pipe coffeelint.reporter 'fail'
