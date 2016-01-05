gulp          = require 'gulp'
jade          = require 'gulp-jade'
stylus        = require 'gulp-stylus'
coffee        = require 'gulp-coffee'
autowatch     = require 'gulp-autowatch'
source        = require 'vinyl-source-stream'
buffer        = require 'vinyl-buffer'
coffeeify     = require 'coffeeify'
browserify    = require 'browserify'


paths =
  public:    './public'
  coffee:    './src/js/**/*.coffee'
  jade:      './src/html/*.jade'
  stylus:    './src/css/*.styl'


gulp.task 'coffee', ->
  bCache = {}
  b = browserify './src/js/app.coffee',
    debug: true
    interestGlobals: false
    cache: bCache
    extensions: ['.coffee']
  b.transform coffeeify
  b.bundle()
  .pipe source 'app.js'
  .pipe buffer()
  .pipe gulp.dest paths.public


gulp.task 'stylus', ->
  gulp.src paths.stylus
  .pipe stylus()
  .pipe gulp.dest paths.public


gulp.task 'watch', ->
  autowatch gulp,
    server: './public/*.html'
    jade:   paths.jade
    stylus: paths.stylus
    coffee: paths.coffee


gulp.task 'server', -> 
  require './server'


gulp.task 'default', ['coffee', 'stylus', 'watch', 'server' ]




 