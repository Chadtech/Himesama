_           = require 'lodash'
HimesamaDoc = require './himesama-doc'
{ createTextNode, getElementById, createElement } = HimesamaDoc

module.exports = Himesama =
  
  el: (type) ->
    ->
      args       = arguments 
      attributes = args[0]
      innerHTML  = []
      _.forEach [ 1 .. args.length ], (i) -> 
        innerHTML.push args[i]
      
      output = createElement type

      if attributes?
        _.forEach (_.keys attributes), (key) =>
          attribute = attributes[key]

          switch key
            when 'onClick'
              output.addEventListener 'click', attribute
            when 'onKeyDown'
              output.addEventListener 'keydown', attribute
            else
              output[key] = attribute

      _.forEach innerHTML, (child) ->
        if child?
          if typeof child is 'string'
            child = createTextNode child
          output.appendChild child

      output


  MountPoint: undefined
  Root:       undefined
  Render: (root, mountPoint) ->
    unless @MountPoint?
      @MountPoint = mountPoint
    unless @Root?
      @Root = root

    content.address = '.0'
    # @MountPoint.removeChild @Root.render()
    @MountPoint.appendChild @Root.render()

  getRender: ->
    @Render.bind @

  initState: (state) ->
    @state      = state
    @components = _.mapValues state, -> []

  getStore: -> @state

  setState: (newValue) -> 
    _.forEach (_.keys newValue), (key) =>
      @state[key] = newValue[key]
    @Render()

  component: (c) -> 
    c.address   = 'charles'
    c.setState  = @setState.bind Himesama
    c.handle    = c.handle.bind c
    c


  Doc: HimesamaDoc