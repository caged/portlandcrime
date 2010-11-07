;(function($) {
  function MapTip(el, target) {
    this.canvas = el
    this.target = target
    this.el = $('<div />')
      .addClass('maptip')
      .css('position', 'absolute')
    
    this.cnt = $('<div />').addClass('maptip-cnt')
    this.el.append(this.cnt)
    this.props = {}
  }
  
  MapTip.prototype = {
    data: function(d) {
      this.props.data = d
      return this
    },
    
    map: function(el) {
      var self = this
      this.props.map = el
      this.props.map.on('move', function() { self.move() })    
      this.props.map.on('resize', function() { self.resize() })
                
      return this
    },
    
    location: function(latlon) {
      this.props.location = latlon
      return this
    },
    
    left: function(fn) {
      if($.isFunction(fn)) {
        this.props.callbackLeft = fn
        this.props.left = fn.call(this, this)
      } else {
        this.props.left = fn
      }
      
      return this
    },
    
    top: function(fn) {
      if($.isFunction(fn)) {
        this.props.callbackTop = fn
        this.props.top = fn.call(this, this)
      } else {
        this.props.top = fn
      }
      
      return this
    },
    
    content: function(fn) {
      if($.isFunction(fn)) {
        this.props.content = fn.call(this, this.props.data)
        return this
      }
      
      this.props.content = fn
      return this
    },
    
    page: function(fn) {
      return this
    },
    
    hide: function(fn) {
      this.el.remove()
    },
    
    move: function(event) {
      this.left(this.props.callbackLeft).top(this.props.callbackTop)
      this.el.css({left: this.props.left + 'px', top: this.props.top + 'px'}) 

      return this
    },
    
    resize: function(event) {
      this.left(this.props.callbackLeft).top(this.props.callbackTop)
      this.el.css({left: this.props.left + 'px', top: this.props.top + 'px'}) 

      return this
    },
    
    render: function() {
      this.cnt.html(' ').append(this.props.content)
      this.canvas.prepend(this.el)  
      this.el.show().css({left: this.props.left + 'px', top: this.props.top + 'px'})
    }
  }
  
  $.fn.maptip = function(target) {
    var tip = $.data(this, 'maptip')
    if(!tip) {
      tip = new MapTip(this, target)
      $.data(this, 'maptip', tip)
    }
    
    return tip 
  }
})(jQuery)