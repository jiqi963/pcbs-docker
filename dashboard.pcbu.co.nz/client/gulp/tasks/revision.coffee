gulp = require 'gulp'
RevAll = require 'gulp-rev-all'

config = require '../config'

revAll = new RevAll {
  dontRenameFile: [
    '.html'
  ]
  dontUpdateReference: [
    '.html'
  ]
  dontSearchFile: [
    '.js'
  ]
}

gulp.task 'revision', ['production:build', 'clean:publicRevisioned'], () ->
  gulp.src config.publicDirectory + '/**/*'
    .pipe revAll.revision()
    .pipe gulp.dest config.publicDirectoryRevisioned
