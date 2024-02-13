sourceDirectory = './src'
publicDirectory = './www'
publicDirectoryRevisioned = './wwwRevisioned'
npmDirectory = './node_modules'
tempDirectory = './temp'

publicFontsDirectory = publicDirectory + '/fonts'

module.exports =
  source:
    scripts: [
      sourceDirectory + '/**/*.{coffee,js}'
    ]
    coffeeScripts: [
      sourceDirectory + '/**/*.coffee'
    ]
    entryScripts: [
      'app.coffee'
    ]
    jadeDocuments: [
      sourceDirectory + '/index.jade'
    ]
    jadeAngularTemplates: [
      sourceDirectory + '/**/*.ng.jade'
      sourceDirectory + '/**/ng.jade'
    ]
    sass: [
      sourceDirectory + '/**/*.sass'
    ]
    entrySass: [
      sourceDirectory + '/styles.sass'
    ]
    sassIncludePaths: [
      npmDirectory + '/bootstrap-sass/assets/stylesheets'
      tempDirectory
    ]
    fonts:
      glyphicons: npmDirectory + '/bootstrap-sass/assets/fonts/bootstrap/**/*.{eot,otf,ttf,woff,woff2,svg}'
    images: [
      sourceDirectory + '/**/*.{jpg,png,svg}'
    ]

  npmDirectory: npmDirectory
  tempDirectory: tempDirectory
  sourceDirectory: sourceDirectory
  publicDirectory: publicDirectory
  publicDirectoryRevisioned: publicDirectoryRevisioned
  publicFontsDirectory: publicFontsDirectory
