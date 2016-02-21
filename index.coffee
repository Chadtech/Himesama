# Dependencies
_       = require 'lodash'
htmlify = require './htmlify'
Merge   = require './merge'

# Utilities
{ getElementById
  createTextNode
  createElement
  querySelectorAll
  querySelector
  getByAttribute } = require './doc'

hk        = 'himesama-id'
textAreas = [ 'text', 'textarea' ]

DOMCreate = (type) ->
  ->
    args    = _.toArray arguments 
    args[0] = {} unless args[0]?

    _.reduce (_.flatten args.slice 1),
      
      (vo, child, i) ->
        if _.isString child
          child = 
            type:      'himesama-text'
            content:   child
        child.parent = vo
        child.index  = i
        vo.children.push child
        vo

      type:         type
      attributes:   args[0]
      children:     []


allocateIds = require './allocate-ids.coffee'



Himesama = 

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
        Himesama.rerender @
      
      attributes = arguments[0]
      needs      = arguments[1]

      H.attributes = {}
      if H.initAttributes?
        H.attributes = H.initAttributes()
      _.forEach (_.keys attributes), (k) =>
        H.attributes[k] = attributes[k]

      if needs?
        if H.needs? 
          H.needs = H.needs.concat needs
        else H.needs = needs

      H.dirty    = false
      H.setState = Himesama.setState.bind Himesama
      H.state    = Himesama.state
      H.type     = 'custom'
      H.children = [ H.render() ]
      H


  initState: (state) -> @state = state


  setState: (payload, next) ->
    keys = _.keys payload
    _.forEach keys, (k) =>
      @state[k] = payload[k]
      return

    _.forEach keys, (k) =>
      @dirtify @vdom, k

    @rerender @vdom

    next?()


  Render: (vdom, mount) ->
    allocateIds vdom, '0'
    @vdom  = vdom
    @mount = mount
    html   = htmlify @vdom
    mount.appendChild html


  dirtify: (node, basis) ->
    { needs, children } = node
    if needs? and basis in needs
      node.dirty = true
    _.forEach children, (child, ci) =>
      @dirtify child, basis


  rerender: (node) ->
    { dirty, children, } = node
    if dirty? and dirty
      node.dirty   = false
      draft        = node.render()
      itsChild     = node.children[0]
      draft.index  = itsChild.index
      draft.parent = itsChild.parent
      # _.forEach (_.keys draft.attributes),
      #   (k) =>
      #     node.attributes[k] = draft.attributes[k]
      # node.attributes = draft.attributes
      @saveActiveText()
      Merge node, draft
      @loadActiveText()
    else
      _.forEach children,
        (child) => @rerender child


  saveActiveText: ->
    el         = document.activeElement
    @activesId = el.getAttribute hk
    if el.type in textAreas
      @textStart = el.selectionStart
      @textEnd   = el.selectionEnd


  loadActiveText: ->
    el = getByAttribute hk, @activesId
    if el?
      el.focus()
      if el.type in textAreas
        el.setSelectionRange @textStart, @textEnd



Himesama.initState = Himesama.initState.bind Himesama
Himesama.Render    = Himesama.Render.bind Himesama
DOM = (require './dom-elements').split ' '
DOM.unshift {}
Himesama.DOM = _.reduce DOM, (sum, el) -> 
  sum[el] = DOMCreate el
  sum


module.exports = Himesama
