gulp = require 'gulp'
bs = require '../lib/browserSync'
config = require '../config/browserSync'

gulp.task 'browserSync', () ->
  bs.init config
