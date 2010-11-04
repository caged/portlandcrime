(function($) {
  function MapTip(el) {
    this.canvas = el
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
      this.props.map = el       
      return this
    },
    
    // canvas: function(el) {
    //   this.props.canvas = $(el)
    //   this.props.canvas.css('position', 'relative')
    //   return this
    // },
    
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
    
    render: function() {
      console.log(this.props.content); 
      this.cnt.html(' ').append(this.props.content)
      this.canvas.prepend(this.el)
      this.el.show()
    }
  }
  
  $.fn.maptip = function() {
    var tip = $.data(this, 'maptip')
    if(!tip) {
      tip = new MapTip(this)
      $.data(this, 'maptip', tip)
    }
    
    return tip 
  }
})(jQuery)