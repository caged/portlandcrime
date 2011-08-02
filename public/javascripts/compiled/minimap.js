/* DO NOT MODIFY. This file was compiled Wed, 27 Jul 2011 19:46:54 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/minimap.coffee
 */

(function() {
  var darkstyle, lightstyle, load, po;
  po = org.polymaps;
  lightstyle = 5870;
  darkstyle = 1960;
  $(function() {
    return $('.minimap').each(function() {
      var code, e, lat, lon, map, svg;
      e = $(this);
      lat = e.data('lat');
      lon = e.data('lon');
      code = e.data('code');
      if (0 === lat || 0 === lon) {
        e.prepend($('<div class="map" />'));
        return;
      }
      svg = po.svg('svg');
      e.prepend(svg);
      map = po.map().container(svg).center({
        lat: lat,
        lon: lon
      }).zoom(15);
      map.add(po.image().url(po.url("http://{S}tile.cloudmade.com/16d73702b7824b57830171b5da5c3c85/" + lightstyle + "/256/{Z}/{X}/{Y}.png").hosts(['a.', 'b.', 'c.', ''])));
      return map.add(po.geoJson().features([
        {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [lon, lat]
          },
          properties: {
            code: code
          }
        }
      ]).on('load', load));
    });
  });
  load = function(e) {
    return $.each(e.features, function() {
      var $cir, $el, el, props;
      el = this.element;
      $el = $(el);
      $cir = $(el.firstChild);
      props = this.data.properties;
      $el.addSVGClass(props.code);
      $cir.addSVGClass('circle');
      $cir.addSVGClass(props.code);
      return $cir[0].setAttribute("r", 6);
    });
  };
}).call(this);
