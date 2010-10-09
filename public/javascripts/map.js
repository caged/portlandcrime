$(function() {
  var po = org.polymaps,
      fetching = false,
      svg = po.svg('svg'),
      map = po.map()
      .container(document.getElementById('map').appendChild(svg))
      .center({lat: 45.5250, lon: -122.6515})
      .zoom(13)
      .on('move', move)
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
  // 
  // 
  // var today    = Date.today().getTime(),
  //     lastweek = Date.today().add(-7).days().getTime();
  
  $.getJSON('/.json', function(data) {
    map.add(po.geoJson()
      .features(data.features)
      .on('load', load))
  })
  
  // $.getJSON('/.json', function(data) {
  //   console.log(data); 
  // })
    
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
          time  = Date.parse(props.reported_at),
          hours = time.getHours(),
          count = parseInt(time.toString('h'))
      
      el.setAttribute('class', 'circle ' + props.code)
      el.setAttribute("r", 12)
      el.setAttribute('alt', time.toString('ddd MMM, dd yyyy hh:mmtt'))
      
      text.setAttribute("transform", trans);
      text.setAttribute('class', props.code)
      text.setAttribute("text-anchor", "middle");
      text.setAttribute("dy", ".35em");
      text.appendChild(document.createTextNode(props.code));
      el.parentNode.insertBefore(text, el.nextSibling);
    })
    
    toggleNodes(null, 'load')
    $('#map').bind('map.togglenodes', toggleNodes)
  }
  
  function toggleNodes(event, from) {
    if(from == 'move')
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
})
