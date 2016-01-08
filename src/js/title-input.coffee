# Libraries
Himesama = require './himesama'
{ el }   = require './himesama'

# DOM
div   = el 'div'
input = el 'input'


module.exports = titleInput = Himesama.Component

  needs: ['title']

  handleKey: (e) -> 
    @setState  title: e.target.value


  render: ->

    console.log 'Rendering title input'

    div className:        'row',
      div className:      'column',
        input
          className:      'cell'
          eventListeners:
            input:        @handleKey
          value:          @state.title