_ = require 'lodash'
window.$ = window.jQuery = $ = require 'jquery'
require 'velocity'

App = require './app'

(() ->
  # DomReady
  $ ->
    App()

)()
