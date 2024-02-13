gulp = require 'gulp'
watch = require 'gulp-watch'

config = require '../config'

gulp.task 'watch', ['browserSync', 'build'], () ->

  watch config.source.scripts, () ->
    gulp.start 'build:js'

  watch config.source.jadeDocuments, () ->
    gulp.start 'build:html'

  watch config.source.jadeAngularTemplates, () ->
    gulp.start 'build:angularTemplates'

  watch config.source.jadeAngularTemplates, () ->
    gulp.start 'build:angularTemplates'

  watch config.source.sass, () ->
    gulp.start 'build:styles'

  watch config.source.images, () ->
    gulp.start 'build:styles'
