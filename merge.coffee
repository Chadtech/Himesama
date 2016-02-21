# Dependencies
_      = require 'lodash'
Diff   = require './diff'
Render = require './render'


# Utilities
{ min, max } = Math 

allocateIds = require './allocate-ids'

eitherAreText = (model, draft) ->
  return true if model.type is 'himesama-text'
  return true if draft.type is 'himesama-text'

hk = 'himesama-id'

adoptId = (model, draft) ->
  draft.attributes[hk] = model.attributes[hk]
  draft

handleCustom = (vo) -> 
  return vo.children[0] if vo.type is 'custom'
  vo

replaceNode   = (model, draft) ->
  i           = model.index
  parent      = model.parent
  children    = parent.children
  children[i] = draft


module.exports = Merge = (model, draft) ->

  model = handleCustom model
  draft = handleCustom draft

  if eitherAreText model, draft
    if model.type isnt 'himesama-text'
      replaceNode model, draft
      Render.nodeToText model, draft
    else
      if draft.type is 'himesama-text'
        unless Diff.strings model, draft
          model.content = draft.content
          Render.text model, draft
      else
        replaceNode model, draft
        Render.textToNode model, draft
  else
    draft = adoptId model, draft
    unless Diff.nodes model, draft
      # Render.node model, draft
      model.attributes = draft.attributes
      model.type       = draft.type
      Render.node model, draft
    mergeChildren model, draft


mergeChildren = (model, draft) ->
  mChildren = model.children
  dChildren = draft.children

  ml = mChildren.length
  dl = dChildren.length

  f  = min ml, dl
  _.times f, (fi) =>
    mChild = mChildren[ fi ]
    dChild = dChildren[ fi ]
    dChild.parent = mChild.parent
    Merge mChild, dChild

  s  = max ml, dl
  if ml > dl
    _.times s - f, =>
      mChild = mChildren[ f ]
      Render.remove mChild, f
      mChildren.splice f, 1
  else
    _.times s - f, (si) =>
      dChild   = dChildren[ si + f ]
      dChild.parent = model
      id       = model.attributes[hk]
      childsId = id + '.' + (si + f)
      allocateIds dChild, childsId
      Render.add model, dChild
      model.children.push dChild
