# Libraries
_ = require 'lodash'

# Utilities
isUpperCase = (l) -> l isnt l.toLowerCase()


module.exports = makeStyleString = (style) ->
  _.reduce ([''].concat _.keys style), (styleAttr, key) ->
    styling = style[key]
    key = _.reduce (key.split ''), (string, char) ->
      smallChar = char.toLowerCase()
      char      = '-' + smallChar if isUpperCase char
      string + char

    styleAttr + key + ': ' + styling + '; '
