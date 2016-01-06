# Libraries
Himesama = require './himesama'
{el}     = require './himesama'

# DOM
p = el 'p'


module.exports = Count = Himesama.Component

  state: Himesama.getStore()
  needs: [ 'counter' ]
  render: ->
    console.log 'Rendering count'

    p null, 
      'Count : ' + @state.counter
