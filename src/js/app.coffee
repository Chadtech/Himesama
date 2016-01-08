# Libraries
Himesama                 = require './himesama'
{ el, Doc, Render }      = Himesama
{ Component, initState } = Himesama
Render                   = Himesama.getRender()
{ getElementById }       = Doc

# DOM
p   = el 'p'
div = el 'div'

# State
Himesama.initState 
  title:       'Himesama..'
  catchPhrase: 'Lets make websites senpai !!'
  count:       0
  words:       []

# Components
Inputs      = require './inputs'
Count       = require './count'
Words       = require './words'
Title       = require './title'
TitleInput  = require './title-input'

App = Himesama.Component

  margin: 9 + 'px'

  render: ->

    console.log 'Rendering App'

    div
      style:
        marginTop:  @margin
        marginLeft: @margin

      # Text Retrived from state
      Title
      TitleInput
      
      p className: 'point', @state.catchPhrase 

      # Components
      Count
      Inputs
      Words


Render App, getElementById 'mount'

