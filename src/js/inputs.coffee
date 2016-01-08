# Libraries
Himesama = require './himesama'
{ el }   = require './himesama'

# DOM
div   = el 'div'
input = el 'input'


module.exports = Inputs = Himesama.Component

  handleUp: (event) ->
    @setState count: @state.count + 1

  handleDown: (event) ->
    @setState count: @state.count - 1
  
  handleSubmit: (e) ->
    if e.which is 13
      @state.words.push e.target.value
      @setState words: @state.words
      e.target.value = ''

  render: ->

    console.log 'Rendering inputs'

    div className: 'row',

      div className:      'column',    
        input 
          className:      'nullButton'
          eventListeners:
            click:        @handleUp
          value:          '+ 1'
          type:           'submit'
      
      div className:      'column', 
        input 
          className:      'nullButton'
          eventListeners:
            click:        @handleDown
          value:          '- 1'
          type:           'submit'

      div className:      'column', 
        input
          className:      'cell'
          eventListeners:
            input:        @handleKey
            keydown:      @handleSubmit
          placeholder:    'type word, press enter'



