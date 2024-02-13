config = require './'
historyApiFallback = require 'connect-history-api-fallback'

module.exports =
  server:
    baseDir: config.publicDirectory
    middleware: [
      historyApiFallback()
    ]
