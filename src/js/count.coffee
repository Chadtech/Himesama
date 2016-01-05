# Libraries
Himesama = require './himesama'
{el}     = require './himesama'

# DOM
p     = el 'p'
div   = el 'div'
input = el 'input'


Count = Himesama.Component

  state: Himesama.getStore()

  needs: [ 'counter' ]

  render: -> 
    p null, 
      'Count : ' + @state.counter


module.exports = Count