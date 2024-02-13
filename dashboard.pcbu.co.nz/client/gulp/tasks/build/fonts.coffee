gulp = require 'gulp'

config = require '../../config'


fontTasks = []
((name, paths) ->
  taskName = 'copy:fonts:' + name
  fontTasks.push taskName
  gulp.task taskName, [], () ->
    gulp.src paths
      .pipe gulp.dest config.publicDirectory + '/fonts/' + name
)(name, paths) for name, paths of config.source.fonts

gulp.task 'copy:fonts', fontTasks


productionFontTasks = []
((name, paths) ->
  taskName = 'production:copy:fonts:' + name
  productionFontTasks.push taskName
  gulp.task taskName, ['clean:public'], () ->
    gulp.src paths
      .pipe gulp.dest config.publicDirectory + '/fonts/' + name
)(name, paths) for name, paths of config.source.fonts

gulp.task 'production:copy:fonts', productionFontTasks
