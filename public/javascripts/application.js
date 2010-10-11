
$.fn.slideFadeToggle = function(speed, callback, easing) {
  return this.animate({height: 'toggle'}, speed, easing, callback);
}

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
  
  /**
   * Expand and collapse of crime groups
   */
  $('span.exp').click(function() {
    var span = $(this)
    var child = span.closest('li').find('ul.offenses')
    child.animate({height: 'toggle'}, 'slow', 'easeOutBack', function() {
      span.toggleClass('collapsed')
    })
  })
  
  $(document).bind('crimes.loaded', function(event, data) {
    var start = Date.today().add(-30).days(),
        end = new Date(),
        range = pv.range(start.getTime(), end.getTime(), 86400000 /* 1 day */),
        hash = {},
        counts = []
    
    $.each(range, function() {
       var d = new Date(this)
       hash[d.toString('MM-dd-yy')] = 0
    })
    
    $.each(data.features, function() {
      var ra = Date.parse(this.properties.reported_at)
      hash[ra.toString('MM-dd-yy')]++
    })
    
   for(var date in hash)
     counts.push(hash[date])
     
     sparkline('#pulse', counts, true)     
     $('#total .num').text(data.features.length)
     
     var last = Date.parse(data.features[0].properties.reported_at) 
     $('#lastreport .val').text(last.toString('ddd MMM, dd yyyy hh:mmtt'))
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