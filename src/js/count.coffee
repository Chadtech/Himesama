# Libraries
Himesama = require './himesama'
{el}     = require './himesama'

# DOM
p = el 'p'


module.exports = Count = Himesama.Component

  needs: [ 'count' ]
  render: ->

    console.log 'Rendering count'

    p className: 'point', 
      'Count : ' + @state.count
