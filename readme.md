# Himesama

Himesama is a JavaScript library for building user interfaces. 

The development of Himesama was made with the intent for it to resemble React as closely as possible. The primary exception, and the chief motivation to develop Himesama, was to build a React-like UI library in which UI components were sensitive to something other than their own internal state or props. 

Himesama, in short, is React with a universal state that any Himesama compnoent can refresh from (should it need to).

# Why Himesama?

React is great, and with the addition of Redux, its ~~technically~~ even better. Lets consider what problem exactly Redux saves React devs from. React is basically perfect, and part of how it works is that each UI component has 'state' which stores values that have some role in rendering. This isnt a problem per se- it does create a wonderful relationship between the app structure and the structure of state-, but it does mean that making React components share values stored in their state a nuisance.

Redux solves that problem for us by implementing React state for us. Rather than in plain React, where we have to define the state of each component and how each component shares its state with others; with Redux we just define a single state, which exists outside of our React app. Redux essentially automates the allocation of state. Its very convenient!

Redux makes sense, but actually using Redux is something no one is happy with. Its a lot of code with dubious necessity, and its a pain in the ass to implement into a project. Remember that Redux is just a wrapper around React, which adds a layer of complexity and confusion. With Redux, React is left as it was, with all of its prior problems. Redux works essentially by hacking React to be sensitive to what React would ideally be sensitive to without Redux in the first place.

Why make a tool like Redux, that makes React work how we would want? Why not take Reacts history as a lesson, and iterate from React something better? Thats Himesama: a React-like UI tool with a single app-wide state.

# How to use Himesama - Examples

0 Just getting something to render

1 Initializing State

2 Using State

3 Or just do things the old fashioned way

## 0 Just getting something to render

Coffeescript
``` coffeescript
Himesama   = require 'himesama'
{ DOM }    = Himesama
{ Render } = Himesama

# DOM
{ p, div } = DOM

App = Himesama.createClass

  render: -> 

    div null,
      p className: 'point', 'Hi Friends'

Render App(), document.getElementById 'mount'
```

Javascript
``` Javascript
var Himesama = require('himesama');
var DOM      = Himesama.DOM;
var Render   = Himesama.Render;

// DOM
var p   = DOM.p;
var div = DOM.div;

var App = Himesamae.createClass({
  render: function(){
    return 
      div(null, 
        p({className:'point'}, 'Hi Friends')
      )
    }
  })

Render(App(), document.getElementById('mount'));
```

Here we are doing nothing more than rendering an attribute-less div, with one child, that child being a p element with the class 'point', and the innerHTML of 'Hi Friends'.

So far nothing special and nothing new. This is how you would render anything in React.

## 1 Initializing State

Coffeescript
``` coffeescript

# ...

# State

{ initState} = Himesama

initState message: 'Hi Friends'


App = Himesama.createClass

  render: ->

# ...

```

Javascript
``` javascript

// ... 

var initState = Himesama.initState;

initState({message: 'Hi Friends'});


var App = Himesama.createClass({

  render: function(){

// ...

```

To initialize our universal state, we pass an object into the function initState. After that, those state values can be referenced and set from any Himesama component.

## 2 Using state

Coffeescript
``` coffeescript
initState count: 0

Counter = Himesama.createClass

  needs: ['count']
  
  render: ->
    {count} = @state

    p className: 'point',
      count + ''

Incrementer = Himesama.createClass

  handle: ->
    {count} = @state
    @setState count: (count + 1)

  render: ->

    input
      type:   'submit'
      value:  '+'
      event:
        click: @handle

App = Himesama.createClass
  
  render: ->
    div null,
      p className: 'point',
        'Hi Friends'
      Counter()
      Incrementer()
```

Javascript
``` javascript
initState({count: 0});

var Counter = Himesama.createClass({
  
  needs: ['count'],

  render: function(){
    return (
      p({className: 'point'},
        count + ''
      )
    )
  }
})

var Incrementer = Himesama.createClass({

  handle: function(){
    var count = @state.count
    this.setState({count:(count + 1)})
  }

  render: function(){
    return (
      input({
        type: 'submit',
        value: '+',
        event: {
          click: this.handle
        }
      })
    )
  }
})

var App = Himesama.createClass({

  render: function(){

    return (
      div(null,
        p({className: 'point'},
          'Hi Friends'),
        Counter(),
        Incrementer()
      )
    )
  }
})

```

To make Himesama components sensitive to certain areas of state, we define their 'needs'. In the Counter component, we can see that it has the property 'needs', which is an array listing what key values of state it needs

Above I mentioned that any component can reference any part of state, and can set any part of state too. When we define a components needs, we arent defining what it 'gets', rather, we are defining what it needs to render. Without specified needs, a component wont necessarily refresh when its state values change. A components list of needs are basically what it needs to show, not what it needs to get (it already gets everything).

And alternatively, as we can see below, the needs of a component can be allocated by a parent component.

Coffeescript
``` coffeescript
  
App = Himesama.createClass
  
  render: ->
    div null,
      p className: 'point',
        'Hi Friends'
      Counter null, ['count']
      Incrementer()

```

Javascript
``` javascript

var App = Himesama.createClass({
  render: function(){
    return (
      div(null,
        p({className:'point'},
          'Hi Friends'),
        Counter(null, ['count']),
        Incremeneter()
      )
    )
  }
})
```

## 3 Or just do things the old fashioned way

Coffeescript
``` coffeescript

Counter = Himesama.createClass

  initAttributes: -> count: 0

  handle: ->
    {count} = @attributes
    @setAttr count: (count + 1)
  
  render: ->
    {count} = @attributes

    p 
      className: 'point'
      events:    (click: @handle),
      count + ''

```

Javascript
``` javascript

var Counter = Himesama.createClass({
  
  initAttributes: function(){
    return {count:0}
  },

  handle: function(){
    var count = this.attributes.count;
    this.setAttr(count:(count + 1));
  },

  render: function(){
    return (
      p({
          className: 'point'
          events:    {click: this.handle}
        },
        count + ''
      )
    )
  }
})


```

Setting and reading form a universal state isnt always the answer, and fortunately in Himesama it doesnt have to be. Just like in React, components have attributes (called 'Props' in React), which can be passed down into components from their parent.

# Development status

As of today (20160221), Himesama works well. I just finished optimizing the diff merge render process. Where Himesama originally destroyed and recreated HTML as changes were made to the VDOM, Himesama now generates two VDOMs, one old and one updated. It merges the two, and edits the HTML only when differences exist between the VDOMs. Everything is great! However, I notice attributes dont 'trickle down' their children. This is an open problem, but not a fatal obstruction to a Himesama dev.

# License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software") to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.