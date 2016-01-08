_            = require 'lodash'
himesamaKeys = require './himesama-keys'
{ createTextNode
  getElementById
  createElement
  querySelectorAll
  activeElement
  querySelector } = require './himesama-doc'
makeStyleString   = require './style-to-string' 

addressKey = 'himesama-address'
IDKey      = 'himesama-id'

getByAttribute = (key, value) ->
  querySelector '[' + key + '="' + value + '"]'

isParentOf = (a, b) ->
  if a isnt b
    _.reduce a, (sum, char, ci) ->
      sum and (char is b[ci])
  else
    false

removeChildren = (addresses) ->
  addresses = _.map addresses, (id) ->
    node    = getByAttribute IDKey, id
    address = node.getAttribute addressKey
    [address, id]

  addresses = _.filter addresses, (address0) ->
    _.reduce addresses, (sum, address1) ->
      sum and not isParentOf address0[0], address1[0]

  _.map addresses, (address) -> address[1]


module.exports = Himesama =
  
  el: (type) ->
    ->
      args       = arguments 
      attributes = args[0]
      innerHTML  = []
      _.forEach ([ 0 .. (args.length - 1) ].slice 1), 
        (i) -> innerHTML.push args[i]
      
      output = createElement type

      if attributes?
        _.forEach (_.keys attributes), (key) =>
          attribute = attributes[key]

          switch key
            when 'className'
              output.setAttribute 'class', attribute
            when 'eventListeners'
              _.forEach (_.keys attribute), (event) =>
                act = attribute[event]
                output.addEventListener event, act
            when 'style'
              style = makeStyleString attribute
              output.setAttribute 'style', style
            else
              output.setAttribute key, attribute

      innerHTML = _.flatten innerHTML
      _.forEach innerHTML, (child, ci) ->
        if child?
          if typeof child is 'string'
            child = createTextNode child
          if child.isHimesama
            id    = child.id
            child = child.render()
            child.setAttribute IDKey, id
          
          output.appendChild child

      output

  Render: (root, mountPoint) ->
    if mountPoint?
      @MountPoint = mountPoint
    if root?
      @Root       = root

    rendering = @Root.render()
    rendering.setAttribute IDKey, @Root.id
    @allocateAddress rendering, '.0'
    @MountPoint.appendChild rendering

  allocateAddress: (el, address) ->
    el.setAttribute addressKey, address
    _.forEach el.children, (child, ci) =>
      @allocateAddress child, address + '.' + ci

  getIndex: (id) ->
    output = ''
    charIndex = id.length - 1
    until id[charIndex] is '.'
      output = id[charIndex] + output
      charIndex--
    output

  Rerender: (stateKey) ->
    addresses = removeChildren @rerenderees[ stateKey ]
    _.forEach addresses, (id) =>

      node = getByAttribute IDKey, id
      if node?

        address = node.getAttribute addressKey
        index   = @getIndex address
        parent  = node.parentElement
        
        activeEl      = document.activeElement
        activeAddress = activeEl.getAttribute addressKey

        if activeEl.type is 'text'
          @textStart = activeEl.selectionStart
          @textEnd   = activeEl.selectionEnd

        node.remove()

        rendering = @components[ id ].render()
        rendering.setAttribute IDKey, id
        @allocateAddress rendering, address

        parent.insertBefore rendering, 
          parent.childNodes[index]

        toFocus = getByAttribute addressKey, activeAddress
        toFocus.focus()

        if toFocus.type is 'text'
          toFocus.setSelectionRange @textStart, @textEnd

  getRender: -> @Render.bind @

  initState: (state) ->
    @state        = state
    @rerenderees  = _.mapValues state, -> []

  getState: -> @state

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

    c.id = (Math.random().toString 36).slice 2
    @components[ c.id ] = c

    _.forEach (c.needs), (need) =>
      @rerenderees[need].push c.id

    c.isHimesama = yes
    c.setState   = @setState.bind Himesama
    c.state      = @getState()
    c


  Doc: require './himesama-doc'


  