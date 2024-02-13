gulp = require 'gulp'
gulpUtil = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'
rename = require 'gulp-rename'
sass = require 'gulp-sass'
bs = require '../../lib/browserSync'

config = require '../../config'

# copy .css to temp dir with .scss extension
gulp.task 'copy:styles:scss:ui-select', ['clean:temp'], () ->
  gulp.src config.npmDirectory + '/ui-select/dist/select.css'
    .pipe rename '_index.scss'
    .pipe gulp.dest config.tempDirectory + '/ui-select'

gulp.task 'copy:styles:scss', ['copy:styles:scss:ui-select']

gulp.task 'build:styles', ['copy:fonts', 'copy:images', 'copy:styles:scss'], () ->
  gulp.src config.source.entrySass
    .pipe sourcemaps.init()
    .pipe sass {
      includePaths: config.source.sassIncludePaths
    }
    .on 'error', gulpUtil.log
    .pipe sourcemaps.write()
    .pipe gulp.dest config.publicDirectory
    .pipe bs.reload {stream: true}

gulp.task 'production:build:styles', ['clean:public', 'production:copy:fonts', 'production:copy:images', 'copy:styles:scss'], () ->
  gulp.src config.source.entrySass
    .pipe sass {
      includePaths: config.source.sassIncludePaths
      outputStyle: 'compressed'
    }
    .on 'error', gulpUtil.log
    .pipe gulp.dest config.publicDirectory
