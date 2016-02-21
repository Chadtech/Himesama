module.exports.getElementById   = document.getElementById.bind    document
module.exports.createTextNode   = document.createTextNode.bind    document
module.exports.createElement    = document.createElement.bind     document
module.exports.querySelectorAll = document.querySelectorAll.bind  document
module.exports.querySelector    = document.querySelector.bind     document
Element.prototype.remove        = -> @parentElement.removeChild @
module.exports.getByAttribute   = (k, v) -> 
  document.querySelector '[' + k + '="' + v + '"]'
