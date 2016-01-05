_           = require 'lodash'
{ createTextNode
  getElementById
  createElement
  querySelectorAll
  activeElement } = require './himesama-doc'

himesamaKeys = require './himesama-keys'


module.exports = Himesama =
  
  el: (type) ->
    ->
      args       = arguments 
      attributes = args[0]
      innerHTML  = []
      _.forEach ([ 0 .. (args.length - 1) ].slice 1), (i) -> 
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
              output.setAttribute key, attribute

      _.forEach innerHTML, (child, ci) ->
        if child?
          if typeof child is 'string'
            child = createTextNode child
          if child.isHimesamaComponent
            child = child.render()

          output.appendChild child

      output

  Render: (root, mountPoint) ->
    if mountPoint?
      @MountPoint = mountPoint
    if root?
      @Root       = root

    (querySelectorAll '[himesama-id]')[0]?.remove()

    rendering = @Root.render()
    allocateID = (element, address) ->
      element.setAttribute 'himesama-id', address
      _.forEach element.children, (child, ci) ->
        allocateID child, address + '.' + ci
    allocateID rendering, '.0'

    @MountPoint.appendChild rendering


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

  Component: (c) -> 

    _.forEach (_.keys c), (key) ->
      unless key in himesamaKeys
        if typeof c[key] is 'function'
          c[key] = c[key].bind c

    c.isHimesamaComponent = true
    c.setState            = @setState.bind Himesama
    c


  Doc: require './himesama-doc'


  