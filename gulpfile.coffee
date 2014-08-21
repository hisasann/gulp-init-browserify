'use strict'

gulp = require 'gulp'
$ = require('gulp-load-plugins')()

browserify = require 'browserify'
watchify = require 'watchify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
colors = require 'colors'
imagemin = require("gulp-imagemin")
pngcrush = require("imagemin-pngcrush")

connect = require 'connect'

# リリースの場合 gulp watch --release
isRelease = $.util.env.release

# JavaScript Task
javascriptFiles = [
#  {
#    input      : ['./src/javascripts/sample1.coffee']
#    output     : 'sample1.js'
#    extensions : ['.coffee']
#    destination: './app/javascripts/'
#  }
#  {
#    input      : ['./src/javascripts/sample2.coffee']
#    output     : 'sample2.js'
#    extensions : ['.coffee']
#    destination: './app/javascripts/'
#  }
  {
    input      : ['./src/javascripts/index.coffee']
    output     : 'index.js'
    extensions : ['.coffee']
    destination: './app/javascripts/'
  }
]

createBundle = (options) ->
  bundleMethod = if global.isWatching then watchify else browserify
  bundler = bundleMethod
    entries   : options.input
    extensions: options.extensions

  rebundle = ->
    startTime = new Date().getTime()
    bundler.bundle
      debug: true
    .on 'error', ->
      console.log arguments
    .pipe(source(options.output))
    .pipe buffer()
    .pipe $.if isRelease, $.uglify({preserveComments: 'some'})    # リリース時は圧縮する
    .pipe $.size(gulp) # jsのファイルサイズ
    .pipe gulp.dest(options.destination)
    .on 'end', ->
      time = (new Date().getTime() - startTime) / 1000
      console.log "#{options.output.cyan} was browserified: #{(time + 's').magenta}"

  if global.isWatching
    bundler.on 'update', rebundle

  rebundle()

createBundles = (bundles) ->
  bundles.forEach (bundle) ->
    createBundle
      input      : bundle.input
      output     : bundle.output
      extensions : bundle.extensions
      destination: bundle.destination

gulp.task 'browserify', ->
  createBundles javascriptFiles


  # browserify使わない場合
#  gulp.src './src/javascripts/*.coffee'
#    .pipe $.plumber()   # エラーが置きても中断させない
#    .pipe $.coffeelint
#      max_line_length:
#        value: 120
#    .pipe $.coffeelint.reporter()
#    .pipe $.coffee({bare: false}).on 'error', (err) ->
#      console.log err
#    .pipe $.if isRelease, $.uglify()    # リリース時は圧縮する
#    .pipe gulp.dest 'app/javascripts/'
#    .pipe $.size() # jsのファイルサイズ


# CSS Task
# sassのcompileとautoprefixer、minify用のcsso
#gulp.task 'sass', ->
#  gulp.src ['./src/stylesheets/style.scss', './src/stylesheets/development.scss']
#    .pipe $.sass
#      errLogToConsole: true
#    .pipe $.autoprefixer 'last 1 version', '> 1%', 'ie 8'
#    .pipe $.if isRelease, $.csso()    # リリース時は圧縮する
#    .pipe $.concat 'all.css'
#    .pipe gulp.dest 'app/stylesheets/'
#    .pipe $.size() #cssのファイルサイズ

# Compass Task
gulp.task 'compass', ->
  gulp.src ['./src/stylesheets/style.scss', './src/stylesheets/development.scss']
    .pipe $.plumber()   # エラーが置きても中断させない
    .pipe $.compass
      config_file: 'config.rb'
      css: 'src/stylesheets'
      sass: 'src/stylesheets'

gulp.task 'concat', ->
  gulp.src ['./app/stylesheets/animate.css', './src/stylesheets/style.css', './src/stylesheets/development.css']
    .pipe $.concat 'all.css'
    .pipe $.if isRelease, $.csso()    # リリース時は圧縮する
    .pipe gulp.dest 'app/stylesheets/'
    .pipe $.size() #cssのファイルサイズ


# 画像の最適化（ただし圧縮率は低い）
gulp.task 'imageop', ->
  gulp.src('src/images/lingerie/*').pipe(imagemin(
    progressive: true
    svgoPlugins: [removeViewBox: false]
    use: [pngcrush()]
    optimizationLevel: 7
  )).pipe gulp.dest('app/images/lingerie2/')


# Server
port = 4567
gulp.task 'connect', ->
  app = connect()
    .use(require('connect-livereload')({port: 35729}))
    .use(connect.static('app'))
    .use(connect.directory('app'));

  http = require 'http'
  http.createServer(app)
    .listen(4567)
    .on 'listening', ->
      console.log 'Start Server on http://localhost:', port

gulp.task 'serve', ['connect', 'browserify', 'compass', 'concat'], ->
  require('opn')('http://localhost:' + port)

gulp.task 'watch', ['connect', 'serve'], ->
  global.isWatching = true

  server = $.livereload()
  # listen livereload server
  $.livereload.listen()

  gulp.watch([
    'app/*.html',
    'app/stylesheets/*.css'
    'app/javascripts/*.js'
  ]).on 'change', (file)->
    server.changed file.path

  gulp.watch './src/javascripts/*.coffee', ['browserify']
  gulp.watch './src/stylesheets/*.scss', ['compass']
  gulp.watch './src/stylesheets/*.css', ['concat']
