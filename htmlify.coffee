# Dependencies
_           = require 'lodash'
styleString = require './style-string.coffee'

# Utilities
{ deCamelCase } = require './utilities'
{ getElementById
  createTextNode
  createElement
  querySelectorAll
  querySelector } = require './doc'


module.exports = htmlify = (vo) ->
  if vo.type is 'custom'
    vo = vo.children[0]

  _.reduce vo.children, 
    (el, child) =>
      child = htmlify child
      el.appendChild child
      el
    Single vo


module.exports.Text = Text = 
  (vo) -> createTextNode vo.content


module.exports.Single = Single = (vo) ->
  return Text vo if vo.type is 'himesama-text'

  _.reduce (_.keys vo.attributes), 
    (el, k) ->
      v = vo.attributes[k]
      k = deCamelCase k
      switch k
        when 'class-name'
          el.setAttribute 'class', v
        when 'style'
          v = styleString v
          el.setAttribute k, v
        when 'event'
          _.forEach (_.keys v), (e) =>
            el.addEventListener e, v[e]
        else
          el.setAttribute k, v
      el
    createElement vo.type

