# Libraries
Himesama = require './himesama'
{ el }   = require './himesama'

# DOM
p = el 'div'


module.exports = TitleInput = Himesama.Component

  needs: ['title']

  render: ->

    console.log 'Rendering title'

    p className: 'point', @state.title