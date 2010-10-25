$(function() {
  if($('body[data-path=trends-index]').length != 0) {
    return
    $.getJSON('/trends.json', function(data) {
      var counts  = $.map(data, function(o) { return o.value.count }),
             max  = Math.max.apply(Math, counts),
          trends  = $('#trends'),
              ol  = $('<ol/>')
          
      
      trends.append(ol)    
      $.each(data, function(idx, week) {
        var percent = (week.value.count / max) * 100 
        var li = $('<li/>').css('height', percent + '%')
        ol.append(li)
        li.append($('<span />')
          .addClass('info')
          .append($('<span/>').text(week.value.count).addClass('num'))
          .append($('<span/>').text(week._id).addClass('range')))
        
        li.mouseover(function() {
          $(this).addClass('on')
        }).mouseout(function() {
          $(this).removeClass('on')
        })
        
        
          
        if(idx % 4 == 0) {
          var mon = Date.parse(week.value.date).toString('MMM'),
              span = $('<span />').addClass('mon').text(mon),
              klass = mon.toLowerCase()
              
          if(ol.find('span.' + klass).length != 1)
            li.append(span.addClass(klass))
        }
      }) 
    })
  }
})