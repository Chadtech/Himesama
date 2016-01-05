# Libraries
Himesama                 = require './himesama'
{ el,  Doc, Render }     = Himesama
{ Component, initState } = Himesama
Render                   = Himesama.getRender()
{ getElementById }       = Doc

# DOM
p     = el 'p'
div   = el 'div'
input = el 'input'

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

  state: Himesama.getStore()

  needs: [
    'title'
    'catchPhrase'
    'counter'
  ]

  render: ->

    div null,
      p null, @state.title
      p null, @state.catchPhrase 
      Inputs
      Count


Render App, getElementById 'mount'

