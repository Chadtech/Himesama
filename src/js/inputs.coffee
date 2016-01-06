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

  render: ->

    console.log 'Rendering inputs'

    div null,
      
      input 
        onClick:   @handleUp
        value:     '+ 1'
        type:      'submit'
      
      input 
        onClick:   @handleDown
        value:     '- 1'
        type:      'submit'

      input
        onKeyDown:    @handleKey
        placeholder:  'type a word, press enter'

