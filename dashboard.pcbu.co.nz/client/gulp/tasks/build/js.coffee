gulp = require 'gulp'
gulpUtil = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'
browserify = require 'browserify'
ngAnnotate = require 'browserify-ngannotate'
uglifyify = require 'uglifyify'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
bs = require '../../lib/browserSync'

config = require '../../config'

gulp.task 'build:js', ['lint:coffee'], () ->
  browserify {
    entries: config.source.entryScripts
    basedir: config.sourceDirectory
    debug: true
    extensions: ['.js', '.coffee']
  }
  .transform coffeeify
  .transform {ext: '.coffee'}, ngAnnotate
  .transform uglifyify
  .bundle()
  .pipe source 'app.js'
  .pipe buffer()
  .on 'error', gulpUtil.log
  .pipe sourcemaps.init {loadMaps: true}
  .pipe sourcemaps.write './'
  .pipe gulp.dest config.publicDirectory
  .pipe bs.reload {stream: true}

gulp.task 'production:build:js', ['clean:public', 'lint:coffee'], () ->
  browserify {
    entries: config.source.entryScripts
    basedir: config.sourceDirectory
    debug: true
    extensions: ['.js', '.coffee']
  }
  .transform coffeeify
  .transform {ext: '.coffee'}, ngAnnotate
  .transform uglifyify
  .bundle()
  .pipe source 'app.js'
  .pipe buffer()
  .on 'error', gulpUtil.log
  .pipe gulp.dest config.publicDirectory
