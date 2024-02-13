gulp = require 'gulp'
jade = require 'gulp-jade'
gulpUtil = require 'gulp-util'
bs = require '../../lib/browserSync'

config = require '../../config'

gulp.task 'build:html', () ->
  gulp.src config.source.jadeDocuments
    .pipe jade {
      locals:
        apiUrl: 'http://localhost:8080/'
    }
    .on 'error', gulpUtil.log
    .pipe gulp.dest config.publicDirectory
    .pipe bs.reload {stream: true}

gulp.task 'production:build:html', ['clean:public'], () ->
  gulp.src config.source.jadeDocuments
    .pipe jade {
      locals:
        apiUrl: '/api/'
    }
    .on 'error', gulpUtil.log
    .pipe gulp.dest config.publicDirectory
