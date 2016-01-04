# Libraries
Himesama              = require './himesama'
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
  counter:     0


Himesama.initState initialState


App = Himesama.component

  state: Himesama.getStore()

  needs: [
    'title'
    'catchPhrase'
    'counter'
  ]

  handleUp: (event) ->
    @setState counter: @state.counter + 1

  handleDown: (event) ->
    @setState counter: @state.counter - 1

  render: ->

    div 'himesama-id': '.0',
      p null, @state.title
      p null, @state.catchPhrase 
      p null, 'Counter : ' + @state.counter
      input 
        onClick:   @handleUp
        value:     '+ 1'
        type:      'submit'
      input 
        onClick:   @handleDown
        value:     '- 1'
        type:      'submit'


Render App, Mount

