$(function() {
  var mapel = $('#neighborhoods-map')
  if(mapel.length == 0) return
  
  var path = $(document.body).data().path,
      po = org.polymaps,
      lightstyle = 5870,
      darkstyle  = 1960,
      svg = po.svg('svg'),
      map = po.map()
      .container(mapel[0].appendChild(svg))
      .center({lat: 45.5250, lon: -122.6515})
      .zoom(11)
      .zoomRange([9,13])
      .add(po.interact())
      .add(po.hash())
      
  map.add(po.image()
      .url(po.url("http://{S}tile.cloudmade.com"
      + "/16d73702b7824b57830171b5da5c3c85" // http://cloudmade.com/register
      + "/" + lightstyle + "/256/{Z}/{X}/{Y}.png")
      .hosts(["a.", "b.", "c.", ""])));
    
   $.getJSON(document.location.pathname + '.geojson', function(data) {
     map.add(po.geoJson()
       .features(data.features)
       .on('load', load))
   })
   
   function load(e) {
     
     $.each(e.features, function() {
       var el = $(this.element),
           props = this.data.properties,
           label    = po.svg('text')
       
       el.addSVGClass('nhood')       
       label.appendChild(document.createTextNode(props.name))
       label.setAttribute("text-anchor", "middle")
       label.setAttribute("dy", ".35em")
       
       el[0].parentNode.appendChild(label)
       
       el.bind('click', {props: props, geo: this.data.geometry}, function(event) {
         document.location = '/neighborhoods/' + event.data.props.permalink 
       })
     })     
     
     if($('#neighborhoods-map .compass').length == 0)
       map.add(po.compass()
         .zoom('small')
         .position('top-left')
         .radius(30)
         .pan('none'))
   }
})