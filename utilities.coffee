# Dependencies
_ = require 'lodash'

isUpperCase = (l) -> l isnt l.toLowerCase()

module.exports = Utilities = 

  deCamelCase: (string) ->
    _.reduce (string.split ''), 
      (sum, char) ->
        if isUpperCase char
          lChar = char.toLowerCase()
          char = '-' + lChar
        sum + char

  delimit: (key, value) ->
    key + ': ' + value + '; '

