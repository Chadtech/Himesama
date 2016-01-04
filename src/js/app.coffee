# Libraries
Himesama              = require './himesama/himesama'
{ el,  Doc, Render }  = Himesama
Render                = Himesama.getRender()
{ getElementById }    = Doc


p       = el 'p'
div     = el 'div'
input   = el 'input'
Mount   = getElementById 'mount'


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
    @setState title: event.target.value + (String.fromCharCode event.which)

  render: ->
    div 'himesama-id': '.0',
      p null, @state.title
      p null, @state.catchPhrase 
      input 
        onKeyDown: @handle
        value:     @state.title


Render App, Mount

