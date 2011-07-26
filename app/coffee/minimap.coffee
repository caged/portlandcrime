po   = org.polymaps
lightstyle = 5870
darkstyle  = 1960
    
$ ->
  $('.minimap').each () ->
    e = $(this)
    lat = e.data('lat')
    lon = e.data('lon')
    code = e.data('code')
    
    svg = po.svg 'svg'
    e.prepend(svg)
    map = po.map()
      .container(svg)
      .center(lat: lat, lon: lon)
      .zoom(15)

    map.add po.image()
      .url(po.url("http://{S}tile.cloudmade.com/16d73702b7824b57830171b5da5c3c85/#{lightstyle}/256/{Z}/{X}/{Y}.png")
        .hosts(['a.', 'b.', 'c.', '']))
    
    map.add(po.geoJson()
      .features([{type:'Feature', geometry: {type:'Point', coordinates: [lon,lat]}, properties: {code: code}}])
      .on('load', load))

load = (e) ->
  $.each e.features, () ->
    el = this.element
    $el = $(el)
    $cir  = $(el.firstChild)
    props = this.data.properties
    
    $el.addSVGClass(props.code)
    $cir.addSVGClass('circle')
    $cir.addSVGClass(props.code)      
    $cir[0].setAttribute("r", 6)