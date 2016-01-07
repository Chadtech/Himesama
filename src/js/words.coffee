# Libraries
Himesama = require './himesama'
{el}     = require './himesama'
_        = require 'lodash'

# DOM
div = el 'div'
p   = el 'p'


module.exports = Words = Himesama.Component

  needs: [ 'words' ]
  render: ->

    console.log 'Rendering words'

    div null, 
      _.map @state.words, (word) ->
        p 
          className: 'point' 
          word


