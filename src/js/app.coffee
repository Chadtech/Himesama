# Libraries
Himesama                 = require './himesama'
{ el,  Doc, Render }     = Himesama
{ Component, initState } = Himesama
Render                   = Himesama.getRender()
{ getElementById }       = Doc

# DOM
p   = el 'p'
div = el 'div'

# State
initialState = 
  title:       'Himesama..'
  catchPhrase: 'Lets make websites senpai!!'
  counter:     0
Himesama.initState initialState

# Components
Inputs = require './inputs'
Count  = require './count'


App = Himesama.Component

  name:  'app'
  state: Himesama.getStore()

  render: ->
    console.log 'Rendering App'

    div null,
      p null, @state.title
      p null, @state.catchPhrase 
      Count
      Inputs

Render App, getElementById 'mount'

