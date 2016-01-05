NodeList.prototype.remove = HTMLCollection.prototype.remove = ->
  for i in [ (@.length - 1) .. 0 ]
    if @[i] and this[i].parentElement
      this[i].parentElement.removeChild this[i]

module.exports.getElementById   = document.getElementById.bind    document
module.exports.createTextNode   = document.createTextNode.bind    document
module.exports.createElement    = document.createElement.bind     document
module.exports.querySelectorAll = document.querySelectorAll.bind  document
module.exports.querySelector    = document.querySelector.bind     document
