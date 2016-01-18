// Generated by CoffeeScript 1.10.0
(function() {
  var DOM, DOMCreate, Himesama, _, activeElement, addressKey, createElement, createTextNode, getElementById, makeStyleString, querySelector, querySelectorAll, ref,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  _ = require('lodash');

  ref = require('./himesama-doc'), createTextNode = ref.createTextNode, getElementById = ref.getElementById, createElement = ref.createElement, querySelectorAll = ref.querySelectorAll, activeElement = ref.activeElement, querySelector = ref.querySelector;

  makeStyleString = require('./style-to-string');

  addressKey = 'himesama-id';

  DOMCreate = function(type) {
    return function() {
      var args;
      args = _.toArray(arguments);
      return {
        type: type,
        attributes: args[0],
        children: _.flatten(args.slice(1))
      };
    };
  };

  Himesama = {
    Doc: require('./himesama-doc'),
    createClass: function(c) {
      return function() {
        var H, attributes;
        H = {};
        _.forEach(_.keys(c), function(k) {
          var v;
          v = c[k];
          if (_.isFunction(v)) {
            v = v.bind(H);
          }
          H[k] = v;
        });
        H.setAttr = function(payload, next) {
          this.dirty = true;
          _.forEach(_.keys(payload), (function(_this) {
            return function(k) {
              return _this.attributes[k] = payload[k];
            };
          })(this));
          return Himesama.Rerender([]);
        };
        attributes = arguments[0];
        H.attributes = {};
        if (H.initAttributes != null) {
          H.attributes = H.initAttributes();
        }
        _.forEach(_.keys(attributes), (function(_this) {
          return function(k) {
            return H.attributes[k] = attributes[k];
          };
        })(this));
        H.dirty = false;
        H.setState = Himesama.setState.bind(Himesama);
        H.state = Himesama.state;
        H.type = 'custom';
        H.children = [H.render()];
        return H;
      };
    },
    setState: function(payload, next) {
      var keys;
      keys = _.keys(payload);
      _.forEach(keys, (function(_this) {
        return function(k) {
          return _this.state[k] = payload[k];
        };
      })(this));
      this.Rerender(keys);
      return typeof next === "function" ? next() : void 0;
    },
    initState: function(state) {
      return this.state = state;
    },
    Render: function(root, mountPoint) {
      this.VirtualDOM = root.render();
      this.allocateAddress(this.VirtualDOM, '.0');
      return mount.appendChild(this.htmlify(this.VirtualDOM));
    },
    Rerender: function(bases) {
      _.forEach(bases, (function(_this) {
        return function(key) {
          return _this.markDirty(_this.VirtualDOM, key);
        };
      })(this));
      return this.handleDirt(this.VirtualDOM);
    },
    markDirty: function(node, basis) {
      if ((node.needs != null) && indexOf.call(node.needs, basis) >= 0) {
        node.dirty = true;
      }
      return _.forEach(node.children, (function(_this) {
        return function(child, ci) {
          return _this.markDirty(child, basis);
        };
      })(this));
    },
    handleDirt: function(node) {
      var activeAddress, activeEl, address, children, element, index, parent, rendering, toFocus;
      children = node.children;
      if ((node.dirty != null) && node.dirty) {
        node.dirty = false;
        address = children[0].attributes[addressKey];
        index = address.slice(0, address.length - 2);
        index = this.getIndex(index);
        element = this.getByAttribute(addressKey, address);
        parent = element.parentElement;
        activeEl = document.activeElement;
        activeAddress = activeEl.getAttribute(addressKey);
        if (activeEl.type === 'text') {
          this.textStart = activeEl.selectionStart;
          this.textEnd = activeEl.selectionEnd;
        }
        element.remove();
        rendering = node.render();
        node.children = [rendering];
        this.allocateAddress(rendering, address);
        parent.insertBefore(this.htmlify(rendering), parent.childNodes[index]);
        toFocus = this.getByAttribute(addressKey, activeAddress);
        if (toFocus != null) {
          toFocus.focus();
        }
        if ((toFocus != null ? toFocus.type : void 0) === 'text') {
          return toFocus.setSelectionRange(this.textStart, this.textEnd);
        }
      } else {
        return _.forEach(children, (function(_this) {
          return function(child) {
            return _this.handleDirt(child);
          };
        })(this));
      }
    },
    allocateAddress: function(node, address) {
      if (!_.isString(node)) {
        if (node.type !== 'custom') {
          if (node.attributes === null) {
            node.attributes = {};
          }
          node.attributes[addressKey] = address;
        }
      }
      return _.forEach(node.children, (function(_this) {
        return function(child, ci) {
          return _this.allocateAddress(child, address + '.' + ci);
        };
      })(this));
    }
  };

  Himesama.Render = Himesama.Render.bind(Himesama);

  Himesama.initState = Himesama.initState.bind(Himesama);

  DOM = (require('./dom-elements')).split(' ');

  Himesama.DOM = _.reduce(DOM, function(sum, el) {
    sum[el] = DOMCreate(el);
    return sum;
  }, {});

  module.exports = _.extend(Himesama, require('./utilities'));

}).call(this);
