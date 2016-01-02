_           = require 'lodash'
HimesamaDoc = require './himesama-doc'
{ createTextNode, getElementById, createElement } = HimesamaDoc

module.exports = Himesama =
  el: (type) ->
    ->
      args       = arguments 
      attributes = args[0]
      innerHTML  = []
      innerHTML.push args[index]
      output = createElement type

      _.forEach innerHTML, (child) ->
        if child?
          if typeof child is 'string'
            child = createTextNode child
          output.appendChild child

      output

  render: (content, mountPoint) ->
    content.address = '.0'
    mountPoint.appendChild content.render()

  initState: (state) ->
    @state      = state
    @components = _.mapValues state, -> []

  getStore: -> @state

  setState: (newValue) -> 
    _.forEach (_.keys newValue), (key) =>
      @state[key] = newValue[key]


  component: (c) -> 
    c.address = 'charles'
    c

    # c.setState = 

  Doc: HimesamaDoc