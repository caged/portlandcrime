$.fn.addSVGClass = function(c) {
  console.log($(this)); 
  var cl = this.getAttribute('class')
  cl.setAttribute('class', cl + ' ' + c)
}

$(function() {
  
  /**
   * Setup all the interactions for enabling and disabling offenses and
   * complete groups of crime types
   */
  var checks = $('span.check')
  checks.click(function() {
    var $this = $(this),
        iac = 'inactive',
        map = $('#map')
    
    if($this.hasClass('group')) {
      var li = $(this).closest('li.otype')
      
      if($this.hasClass(iac)) {        
        $this.removeClass(iac)
        li.find('span.check').removeClass(iac)
      } else {
        $this.addClass(iac)
        li.find('span.check').addClass(iac)
      }
    } else {
      if($this.hasClass(iac)) {
        $this.removeClass(iac)
        $this.closest('li.otype')
          .find('span.group')
          .removeClass(iac)
      } else {
        $this.addClass('inactive')
      }     
    }
    $('#map').trigger('map.togglenodes')
  })
  
  
  $('span.exp').click(function() {
    var span = $(this)
    var child = span.closest('li').find('ul.offenses')
    child.slideToggle(450, function() {
      span.toggleClass('collapsed')
    }) 
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