# Libraries
Himesama = require './himesama'
{el}     = require './himesama'

# DOM
div   = el 'div'
input = el 'input'


module.exports = Inputs = Himesama.Component

  handleUp: (event) ->
    @setState counter: @state.counter + 1

  handleDown: (event) ->
    @setState counter: @state.counter - 1

  handleKey: (event) ->
    if event.which is 13
      @state.words.push event.target.value
      @setState words: @state.words
      event.target.value = ''

  render: ->

    console.log 'Rendering inputs'

    div className: 'row',

      div className: 'column',    
        input 
          className: 'nullButton'
          onClick:   @handleUp
          value:     '+ 1'
          type:      'submit'
      
      div className: 'column', 
        input 
          className: 'nullButton'
          onClick:   @handleDown
          value:     '- 1'
          type:      'submit'

      div className: 'column', 
        input
          className:    'cell'
          onKeyDown:    @handleKey
          placeholder:  'type a word, press enter'

