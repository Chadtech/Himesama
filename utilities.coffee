_ = require 'lodash'
{ createTextNode
  getElementById
  createElement
  querySelectorAll
  activeElement
  querySelector } = require './himesama-doc'
makeStyleString   = require './style-to-string' 

isUpperCase = (l) -> l isnt l.toLowerCase()

module.exports = Utilities = 

  htmlify: (component) ->
    if _.isString component then createTextNode component
    else
      if component.type is 'custom'
        component = component.children[0]
      keys = _.keys component.attributes
      output = _.reduce keys, 
        (el, key) ->
          attribute = component.attributes[key]

          switch key
            when 'className'
              el.setAttribute 'class', attribute
            when 'style'
              style = makeStyleString attribute
              el.setAttribute 'style', style
            when 'event'
              _.forEach (_.keys attribute), (event) =>
                act = attribute[event]
                el.addEventListener event, act
            else
              key = key.split ''
              key = _.reduce key, (str, char) ->
                if isUpperCase char
                  char = '-' + char.toLowerCase()
                str + char
              el.setAttribute key, attribute
              
          el

        createElement component.type

      _.forEach component.children, (child) =>
        output.appendChild @htmlify child

      output


  getByAttribute:  (key, value) ->
    querySelector '[' + key + '="' + value + '"]'


  getIndex: (id) ->
    output = ''
    ci = id.length - 1
    until id[ci] is '.'
      output = id[ci] + output
      ci--
    output
