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
  words:       []
Himesama.initState initialState

# Components
Inputs = require './inputs'
Count  = require './count'
Words  = require './words'


App = Himesama.Component

  render: ->

    console.log 'Rendering App'

    div null,
      p className: 'point', @state.title
      p className: 'point', @state.catchPhrase 
      Count
      Inputs
      Words

Render App, getElementById 'mount'

