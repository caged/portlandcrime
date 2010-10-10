$.fn.addSVGClass = function(c) {
  var el = this[0],
      cl = el.getAttribute('class')
  
  if(!cl) cl = ' ';    
  cl = cl.split(' ')
  if(cl.indexOf(c) == -1) {
    cl.push(c)
    el.setAttribute('class', cl.join(' '))
  }
  
  return this
}

$.fn.removeSVGClass = function(c) {
  var el = this[0]
      cl = el.getAttribute('class')
      
  cl = cl.split(' ')
  var idx = cl.indexOf(c)
  if(idx != -1) {
    cl.splice(idx, 1)
    el.setAttribute('class', cl.join(' '))
  }
  
  return this
}

$.fn.hasSVGClass = function(c) {
  var el = this[0]
      cl = el.getAttribute('class')
      has = false
      
  cl = cl.split(' ')
  var idx = cl.indexOf(c)
  if(idx != -1)
    has = true
    
  return has
}

$.fn.slideFadeToggle = function(speed, callback, easing) {
  return this.animate({
      height: 'toggle'
    }, speed, easing, callback);
};

$(function() {
  
  /**
   * Setup all the interactions for enabling and disabling offenses and
   * complete groups of crime types
   */
  var checks = $('span.check')
  checks.click(function() {
    var check = $(this),
        iac = 'inactive'
    
    if(check.hasClass('group')) {
      var li = check.closest('li.group'),
          children = li.find('span.check')
          
      if(check.hasClass(iac)) {
        check.removeClass(iac)
        children.removeClass(iac)
      } else {
        check.addClass(iac)
        children.addClass(iac)
      }
    } else {
      if(check.hasClass(iac)) {
        check.removeClass(iac)
          .closest('li.group')
          .find('span.group')
          .removeClass(iac)
      } else {
        check.addClass(iac)
      }
    }

    $('#map').trigger('map.togglecrimes')
  })
  
  
  $('span.exp').click(function() {
    var span = $(this)
    var child = span.closest('li').find('ul.offenses')
    child.slideFadeToggle('slow', function() {
      span.toggleClass('collapsed')
    }, 'easeOutBack') 
  })
})


String.prototype.capitalizeWords = function() {
  var words = ""
  this.toLowerCase().split(/\-|\s|\/|\,/).forEach(function(word) {
    var tmp = word.charAt(0).toUpperCase() + word.slice(1),
        dir = $.grep(['SE', 'NE', 'SW', 'NW'], function(d) { return d == tmp.toUpperCase() })
    tmp = dir.length == 1 ? dir[0] : tmp
    words += ' ' + tmp
  })
  return words
};