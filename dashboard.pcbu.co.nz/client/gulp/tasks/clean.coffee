gulp = require 'gulp'
del = require 'del'

config = require '../config'

gulp.task 'clean:public', (done) ->
  del config.publicDirectory, done

gulp.task 'clean:publicRevisioned', (done) ->
  del config.publicDirectoryRevisioned, done

gulp.task 'clean:temp', (done) ->
  del config.tempDirectory, done

gulp.task 'clean', ['clean:public', 'clean:publicRevisioned', 'clean:temp']
