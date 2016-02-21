# Dependencies
_           = require 'lodash'
styleString = require './style-string.coffee'

VDOMToString = (vo) ->
  keys = _.keys vo.attributes
  attributes = _.map keys, (k) ->
    v = vo.attributes[k]
    v = styleString v if k is 'style'
    k = 'class' if k is 'className'

    if k is 'event' then ''
    else k + '=' + v + ' '

  _.reduce attributes, 
    (sum, attr) -> sum + attr
    vo.type + ' '


module.exports = Diff = 
  nodes: (a, b) ->
    a = VDOMToString a
    b = VDOMToString b
    a is b

  strings: (a, b) ->
    a.content is b.content