_ = require 'lodash'
{ createTextNode
  getElementById
  createElement
  querySelectorAll
  activeElement
  querySelector } = require './himesama-doc'
makeStyleString   = require './style-to-string' 

addressKey = 'himesama-id'

DOMCreate = (type) ->
  ->
    args       = _.toArray arguments 

    type:       type
    attributes: args[0]
    children:   _.flatten (args.slice 1)



Himesama = 


  Doc: require './himesama-doc'


  createClass: (c) -> 
    ->
      H = {}
      _.forEach (_.keys c), (k) ->
        v = c[k]
        v = v.bind H if _.isFunction v
        H[k] = v
        return

      H.setAttr = (payload, next) ->
        @dirty  = true
        _.forEach (_.keys payload), (k) =>
          @attributes[k] = payload[k]
        Himesama.Rerender []
      
      attributes = arguments[0]
      needs      = arguments[1]

      H.attributes = {}
      if H.initAttributes?
        H.attributes = H.initAttributes()
      _.forEach (_.keys attributes), (k) =>
        H.attributes[k] = attributes[k]

      if needs?
        if H.needs? then H.needs.concat needs
        else H.needs = needs

      H.dirty    = false
      H.setState = Himesama.setState.bind Himesama
      H.state    = Himesama.state
      H.type     = 'custom'
      H.children = [ H.render() ]
      H


  setState: (payload, next) ->
    keys = _.keys payload
    _.forEach keys, (k) =>
      @state[k] = payload[k]
    @Rerender keys
    next?()


  initState: (state) -> @state = state


  Render: (root, mountPoint) ->
    @VirtualDOM  = root.render()
    @allocateAddress @VirtualDOM, '.0'
    mount.appendChild @htmlify @VirtualDOM


  Rerender: (bases) ->
    _.forEach bases, (key) =>
      @markDirty @VirtualDOM, key
    @handleDirt @VirtualDOM


  markDirty: (node, basis) ->
    if node.needs? and basis in node.needs
      node.dirty = true
    _.forEach node.children, (child, ci) =>
      @markDirty child, basis


  handleDirt: (node) ->
    children = node.children
    if node.dirty? and node.dirty
      node.dirty = false
      # We are re rendering the node
      # because its dirty


      # Get the html element, get its address,
      # gets its parent, get get its index number 
      # within its parent
      address = children[0].attributes[addressKey]
      index   = address.slice 0, address.length - 2
      index   = @getIndex index
      element = @getByAttribute addressKey, address
      parent  = element.parentElement

      # Get the active element, ie, the one
      # with the text caret in it (like an
      # input or a textarea)
      activeEl      = document.activeElement
      activeAddress = activeEl.getAttribute addressKey
      
      # Get where the caret is (or, the text
      # selection starts and stops )
      if activeEl.type is 'text'
        @textStart = activeEl.selectionStart
        @textEnd   = activeEl.selectionEnd

      # Get rid of that old dirty node
      element.remove()

      # Render up a fresh clean node
      rendering     = node.render()
      node.children = [ rendering ]
      @allocateAddress rendering, address

      # Insert it under its parent, where
      # we found it
      parent.insertBefore (@htmlify rendering),
        parent.childNodes[ index ]

      # Focus back on the element that was active
      # before we did this re rendering stuff
      toFocus = @getByAttribute addressKey, activeAddress
      toFocus?.focus()
      if toFocus?.type is 'text'
        toFocus.setSelectionRange @textStart, @textEnd

    else
      # If its not dirty, look deeper
      _.forEach children, (child) => @handleDirt child


  allocateAddress: (node, address) ->
    unless _.isString node 
      if node.type isnt 'custom'
        node.attributes = {} if node.attributes is null
        node.attributes[addressKey] = address

    _.forEach node.children, (child, ci) =>
      @allocateAddress child, address + '.' + ci


Himesama.Render    = Himesama.Render.bind Himesama
Himesama.initState = Himesama.initState.bind Himesama
DOM                = (require './dom-elements').split ' '
Himesama.DOM       = _.reduce DOM, 
  (sum, el) -> 
    sum[el] = DOMCreate el
    sum
  {}


module.exports = _.extend Himesama, require './utilities'

