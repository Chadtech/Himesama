# Libraries
Himesama            = require './himesama/Himesama'
{ el, render, Doc } = require './himesama/Himesama'
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

  needs: [
    'title'
    'catchPhrase'
  ]

  render: ->
    div null,
      p null, state.title
      p null, state.catchPhrase 
      input null   


render App, content
