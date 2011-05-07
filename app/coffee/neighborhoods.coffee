$ ->
  mapel = $ '#neighborhoods-map'
  return if mapel.length == 0
  
  path = $(document.body).data().path
  po   = org.polymaps
  lightstyle = 5870
  darkstyle  = 1960
  svg = po.svg 'svg'
  map = po.map()
    .container(mapel[0].appendChild(svg))
    .center(lat: 45.5250, lon: -122.6515)
    .zoom(11)
    .zoomRange([9,17])
    .add(po.interact())
    .add(po.hash())
    
  map.add po.image()
    .url(po.url("http://{S}tile.cloudmade.com/16d73702b7824b57830171b5da5c3c85/#{lightstyle}/256/{Z}/{X}/{Y}.png")
      .hosts(['a.', 'b.', 'c.', '']))
      
  $.getJSON "#{document.location.pathname}.geojson", (data) ->
    map.add(po.geoJson()
      .features(data.features)
      .on('load', load))
      
  load = (e) ->
    console.log 'loading'
    $.each e.features, () ->
      el = $(this.element)
      props = this.data.properties
      label = po.svg 'text'
    
      el.addSVGClass 'nhood'
      
      el.mouseover () -> el.addSVGClass 'over'
      el.mouseout () ->  el.removeSVGClass 'over'
       
      el.bind 'click', {props: props, geo: this.data.geometry}, (event) ->
        document.location = "/neighborhoods/#{event.data.props.permalink}"