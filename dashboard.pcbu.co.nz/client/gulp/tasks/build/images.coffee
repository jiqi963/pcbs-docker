gulp = require 'gulp'

config = require '../../config'

gulp.task 'copy:images', () ->
  gulp.src config.source.images
    .pipe gulp.dest config.publicDirectory + '/images'

gulp.task 'production:copy:images', ['clean:public'], () ->
  gulp.src config.source.images
    .pipe gulp.dest config.publicDirectory + '/images'
