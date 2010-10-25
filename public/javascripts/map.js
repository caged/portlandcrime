$(function() {
  var map = document.getElementById('map')
  if(!map) return
  
  var po = org.polymaps,
      fetching = false,
      svg = po.svg('svg'),
      map = po.map()
      .container(map.appendChild(svg))
      .center({lat: 45.5250, lon: -122.6515})
      .zoom(13)
      .zoomRange([9,18])
      .add(po.interact())
      
  map.add(po.image()
      .url(po.url("http://{S}tile.cloudmade.com"
      + "/16d73702b7824b57830171b5da5c3c85" // http://cloudmade.com/register
      + "/5870/256/{Z}/{X}/{Y}.png")
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
  
  function load(e) {   
    var counts = {}  
    $.each(e.features, function() {
      var el = this.element,
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
        $(el).addSVGClass('inactive')

      $(el).addSVGClass('circle').addSVGClass(props.code)
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
