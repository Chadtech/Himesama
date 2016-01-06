_            = require 'lodash'
himesamaKeys = require './himesama-keys'
{ createTextNode
  getElementById
  createElement
  querySelectorAll
  activeElement
  querySelector } = require './himesama-doc'



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
            name  = child.name
            child = child.render()
            child.setAttribute 'himesama-name', name

          output.appendChild child

      output

  Render: (root, mountPoint) ->
    if mountPoint?
      @MountPoint = mountPoint
    if root?
      @Root       = root

    rendering = @Root.render()
    @allocateID rendering, '.0'
    @MountPoint.appendChild rendering

  allocateID: (element, address) ->
    element.setAttribute 'himesama-id', address
    _.forEach element.children, (child, ci) =>
      @allocateID child, address + '.' + ci

  getIndex: (id) ->
    output = ''
    charIndex = id.length - 1
    until id[charIndex] is '.'
      output = id[charIndex] + output
      charIndex--
    output

  Rerender: (statePiece) ->
    _.forEach @rerenderees[statePiece], (name) =>
      nameTag       = '[himesama-name="' + name + '"]'
      himesamaNode  = querySelector nameTag
      nodeIndex     = himesamaNode.getAttribute 'himesama-id'
      index         = @getIndex nodeIndex

      parent        = himesamaNode.parentElement
      himesamaNode.remove()

      parentsID     = parent.getAttribute 'himesama-id'
      childrenCount = parent.children.length - 1

      rendering = @components[name].render()
      rendering.setAttribute 'himesama-name', name
      @allocateID rendering, nodeIndex

      parent.insertBefore rendering, parent.childNodes[index]


  getRender: ->
    @Render.bind @

  initState: (state) ->
    @state        = state
    @rerenderees  = _.mapValues state, -> []

  getStore: -> @state

  setState: (newValue) -> 
    _.forEach (_.keys newValue), (key) =>
      @state[key] = newValue[key]
      @Rerender key

  components: {}

  Component: (c) -> 

    _.forEach (_.keys c), (key) ->
      unless key in himesamaKeys
        if typeof c[key] is 'function'
          c[key] = c[key].bind c

    componentId = (Math.random().toString 16).slice 2
    c.name      = componentId
    @components[componentId] = c

    _.forEach (c.needs), (need) =>
      @rerenderees[need].push c.name


    c.isHimesamaComponent = true
    c.setState            = @setState.bind Himesama



    c


  Doc: require './himesama-doc'


  