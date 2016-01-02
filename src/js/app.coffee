# Libraries
Himesama            = require './himesama/Himesama'
{ el,  Doc }        = require './himesama/Himesama'
Render              = Himesama.getRender()
{ getElementById }  = Doc


p       = el 'p'
div     = el 'div'
input   = el 'input'
Content = getElementById 'content'


initialState = 
  title:       'Himesama..'
  catchPhrase: 'Lets make websites senpai!!'

Himesama.initState initialState

App = Himesama.component

  state: initialState

  needs: [
    'title'
    'catchPhrase'
  ]

  handle: (event) ->
    @setState title: event.target.value

  render: ->
    div null,
      p null, @state.title
      p null, @state.catchPhrase 
      input 
        onKeyDown: @handle
        value:     @state.title


Render App, content


