gulp = require 'gulp'
jade = require 'gulp-jade'
templateCache = require 'gulp-angular-templatecache'
bs = require '../../lib/browserSync'

config = require '../../config'

gulp.task 'build:angularTemplates', () ->
  gulp.src config.source.jadeAngularTemplates
    .pipe jade()
    .pipe templateCache {
      standalone: true
    }
    .pipe gulp.dest config.publicDirectory
    .pipe bs.reload {stream: true}

gulp.task 'production:build:angularTemplates', ['clean:public'], () ->
  gulp.src config.source.jadeAngularTemplates
    .pipe jade()
    .pipe templateCache {
      standalone: true
    }
    .pipe gulp.dest config.publicDirectory
