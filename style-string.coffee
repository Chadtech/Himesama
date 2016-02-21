# Dependencies
_ = require 'lodash'

{ deCamelCase, delimit } = require './utilities'

module.exports = StyleString = (style) ->
  _.reduce (_.keys style), 
    (v, key) ->
      styling = style[key]
      key     = deCamelCase key
      v + (delimit key, styling)
    ''