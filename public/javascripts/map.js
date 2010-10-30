$(function() {
  var mapel = $('#map')
  if(mapel.length == 0) return
  
  var po = org.polymaps,
      lightstyle = 5870,
      darkstyle  = 1960,
      svg = po.svg('svg'),
      map = po.map()
      .container(mapel[0].appendChild(svg))
      .center({lat: 45.5250, lon: -122.6515})
      .zoom(13)
      .zoomRange([9,18])
      .add(po.interact())
      
  map.add(po.image()
      .url(po.url("http://{S}tile.cloudmade.com"
      + "/16d73702b7824b57830171b5da5c3c85" // http://cloudmade.com/register
      + "/" + lightstyle + "/256/{Z}/{X}/{Y}.png")
      .hosts(["a.", "b.", "c.", ""])));

  map.add(po.compass()
    .zoom('small')
    .position('top-left')
    .radius(30)
    .pan('none'))
  
  $(document).bind('ajaxStart', function() { fetching = true })
             .bind('ajaxEnd', function() { fetching = false })

    $.getJSON(document.location.pathname + '.json', function(data) {
      $(document).trigger('crimes.loaded', data)
      map.add(po.geoJson()
        .features(data.features)
        .on('load', load))
    })


  $('.compass').click(togglecrimes)
  
  $(document).keyup(function(e) {
    if (e.keyCode == 27) { $('.resizer').click(); }   // esc
  });
  
  var resizer = $('<span />').addClass('resizer').text('`'),
      width = mapel.width(),
      height = mapel.height(),
      body   = $(document.body),
      logo   = $('<img />')
        .attr('src', '/images/logo-small.png')
        .addClass('fslogo'),
      hdr    = $('header#top .wrap-inner')
  
      
  resizer.bind('click', function(event) {
    if(body.hasClass('fullscreen')) {
      body.removeClass('fullscreen')
      mapel.find('header').show()
      mapel.css({position: null, width: width, height: height})
      logo.remove()      
    } else {
      body.addClass('fullscreen')
      mapel.find('header').hide()
      mapel.css({position: 'fixed', top: 0, right: 0, width: '100%', height: '100%'})
      mapel.find('svg').css({ width: '100%', height: '100%'})
      mapel.prepend(logo.remove())
    }
    
    map.resize()
  })
  
  mapel.prepend(resizer)
  
  function load(e) {   
    var counts = {}  
    $.each(e.features, function() {
      var el = this.element,
          $el   = $(el)
          props = this.data.properties,
          text  = po.svg('text'),
          trans = el.getAttribute("transform"),
          time  = Date.parse(props.reported_at),
          hours = time.getHours(),
          count = parseInt(time.toString('h')),
          check = $('span.check[data-code=' + props.code + ']'),
          inact = check.hasClass('inactive')
      
      if(!counts[props.code]) counts[props.code] = 0
      counts[props.code]++
      
      if(inact)
        $el.addSVGClass('inactive')

      $el.addSVGClass('circle').addSVGClass(props.code)
      if(time.isDaylight()) $el.addSVGClass('day') 
      if(time.isDark()) $el.addSVGClass('dar') 
      if(time.isWeekendNightlife()) $el.addSVGClass('wnl') 
      
      
      el.setAttribute("r", 12)
      el.setAttribute('alt', time.toString('ddd MMM, dd yyyy hh:mmtt'))
      
      $(el).bind('click', {props: props, geo: this.data.geometry}, function(event) {
        console.log(event.data); 
      })
      
      if(inact)
        $(text).addSVGClass('inactive')
        
      $(text).addSVGClass(props.code)
      text.setAttribute("transform", trans);
      text.setAttribute("text-anchor", "middle");
      text.setAttribute("dy", ".35em");
      text.appendChild(document.createTextNode(props.code));
      el.parentNode.insertBefore(text, el.nextSibling);
    })
    
    $('#sbar li.off').each(function() {
      var el = $(this),
          cnt = el.find('span.count')
      if(cnt.length == 0) {
        var check = el.find('span.check')
        var code = check.attr('data-code')
        
        if(!counts[code]) counts[code] = 0
        
        check.parent()
          .append($('<span class="count" />')
          .text(counts[code]))
      }
    })
    //togglecrimes(null, 'load')
    $('#map').bind('map.togglecrimes', togglecrimes)    
  }
  
  function togglecrimes(event, from) {
    $('#sbar span.check').each(function() {
      var check = $(this),
          code  = check.attr('data-code'),
          klass = this.getAttribute('class'),
          nodes = $('.circle.' + code + ', text.' + code)
      
      if(klass.indexOf('inactive') != -1) {
        nodes.each(function() { $(this).addSVGClass('inactive') })
      } else {
        nodes.each(function() { $(this).removeSVGClass('inactive') })
      }
    }) 
  }
})
