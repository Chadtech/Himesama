# Dependencies
_ = require 'lodash'

module.exports = allocateIds = (vo, id) ->
  if vo.type is 'custom'
    vo = vo.children[0]

  { attributes, children } = vo
  idAttr = 'himesama-id': id
  _.extend attributes, idAttr
  _.forEach children, (child, i) =>
    allocateIds child, id + '.' + i