browserSync = require 'browser-sync'

name = 'bsServer'

try
  instance = browserSync.get name
catch error
  instance = browserSync.create name unless instance

module.exports = instance
