$(function() {
  var po = org.polymaps,
      fetching = false,
      svg = po.svg('svg'),
      map = po.map()
      .container(document.getElementById('map').appendChild(svg))
      .center({lat: 45.5250, lon: -122.6515})
      .zoom(13)
      // .on('resize', resize)
      .on('move', move)
      .add(po.interact()),
      loaded = false
      
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
  
  
  var today    = Date.today().getTime(),
      lastweek = Date.today().add(-7).days().getTime();
  
  map.add(po.geoJson()
    .url('/events?from=' + lastweek + '&to=' + today)
    .on('load', load))
    
  // map.add(po.geoJson()
  //   .url('/data/neighborhoods.json')
  //   .on('load', loadneighborhoods)
  //   .clip(false))
    
  // function loadneighborhoods(e) {
  //   $.each(e.features, function() {
  //     var el    = this.element,
  //         props = this.data.properties
  //     
  //     el.setAttribute('class', 'park')
  //     el.setAttribute('name', props.NAME)
  //     $(el).bind('mousedown', {props: props}, function(event) {
  //       console.log(event.data.props.NAME); 
  //     })
  //   })
  // }

  
  function load(e) {     
    $.each(e.features, function() {
      var el = this.element,
          props = this.data.properties,
          text  = po.svg('text'),
          trans = el.getAttribute("transform"),
          date  = props.date.replace('Z', '').replace('.000', ''),
          time  = Date.parse(date),
          hours = time.getHours(),
          count = parseInt(time.toString('h'))
      
      var klass = props.offense
        .replace(/^\s+|\s+$/g, '')
        .replace(/\s+|\/|\,/g, '-')
        .replace(/-{2,}/g, '-')
        .toLowerCase(),
        code = klass.substr(0,2)
      
      el.setAttribute('class', 'circle ' + code)
      el.setAttribute("r", 12)
      el.setAttribute('alt', time.toString('ddd MMM, dd yyyy hh:mmtt'))
      
      text.setAttribute("transform", trans);
      text.setAttribute('class', code)
      text.setAttribute("text-anchor", "middle");
      text.setAttribute("dy", ".35em");
      text.appendChild(document.createTextNode(code));
      el.parentNode.insertBefore(text, el.nextSibling);
      
      $('a.locate').click(function() {
        var $this = $(this)
        $this.addClass('finding')
        navigator.geolocation.getCurrentPosition(
          function(position) {
            map
              .center({lat: position.coords.latitude, lon: position.coords.longitude})
              .zoom(16)
            $this.removeClass('finding')
          }, 
          function(err) {
            console.log(err); 
          }, 
          {
            enableHighAccuracy: true
          })
      })
    })
    
    toggleNodes(null, 'load')
    $('#map').bind('map.togglenodes', toggleNodes)
  }
  
  function toggleNodes(event, from) {
    $('#sbar span.check').each(function() {
      var check = $(this),
          code  = check.attr('data-code'),
          klass = this.getAttribute('class'),
          circles = $('.circle.' + code),
          labels  = $('text.' + code)
      
      if(klass.indexOf('inactive') != -1) {
        circles.each(function() {
          var cklass = this.getAttribute('class')
          if(cklass.indexOf('inactive') == -1)
            this.setAttribute('class', cklass + ' inactive')
        })
        
        labels.each(function() {
          var lklass = this.getAttribute('class')
          if(lklass.indexOf('inactive') == -1)
            this.setAttribute('class', lklass + ' inactive')
        })
      } else {
        circles.each(function() {
          var cklass = this.getAttribute('class')
          this.setAttribute('class', cklass.replace(/inactive/gi, ''))
        })
        
        labels.each(function() {
          var lklass = this.getAttribute('class')
          this.setAttribute('class', lklass.replace(/inactive/gi, ''))
        })
      }
    }) 
  }
  
  function move(event) {
    toggleNodes(event, 'move')
  }
  // 
  // function resize(map) {
  //   console.log(map); 
  // }
  
  // function activate(e, nodes) {
  //   $.each(nodes, function(idx, code) {
  //     var points = $('.circle.' + code + ', text.' + code)
  //     if(points.length != 0) {
  //       $.each(points, function() {
  //         var c = this.getAttribute('class')
  //         c = c.replace(/\binactive\b/g, '')
  //         this.setAttribute('class', c) 
  //       })
  //     }
  //   })
  // }
  // 
  // function deactivate(e, nodes) {
  //   $.each(nodes, function(idx, code) {  
  //     var points = $('.circle.' + code + ', text.' + code)
  //     if(points.length != 0) {
  //       $.each(points, function() {
  //         var c = this.getAttribute('class')
  //         this.setAttribute('class', c + ' inactive') 
  //       })
  //     }
  //   })
  // }
})
