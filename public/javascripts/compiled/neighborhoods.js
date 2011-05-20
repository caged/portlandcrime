/* DO NOT MODIFY. This file was compiled Fri, 20 May 2011 00:15:56 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/neighborhoods.coffee
 */

(function() {
  $(function() {
    var darkstyle, lightstyle, load, map, mapel, path, po, svg;
    mapel = $('#neighborhoods-map');
    if (mapel.length === 0) {
      return;
    }
    path = $(document.body).data().path;
    po = org.polymaps;
    lightstyle = 5870;
    darkstyle = 1960;
    svg = po.svg('svg');
    map = po.map().container(mapel[0].appendChild(svg)).center({
      lat: 45.5250,
      lon: -122.6515
    }).zoom(11).zoomRange([9, 17]).add(po.interact()).add(po.hash());
    map.add(po.image().url(po.url("http://{S}tile.cloudmade.com/16d73702b7824b57830171b5da5c3c85/" + lightstyle + "/256/{Z}/{X}/{Y}.png").hosts(['a.', 'b.', 'c.', ''])));
    $.getJSON("" + document.location.pathname + ".geojson", function(data) {
      return map.add(po.geoJson().features(data.features).on('load', load));
    });
    return load = function(e) {
      console.log('loading');
      return $.each(e.features, function() {
        var el, label, props;
        el = $(this.element);
        props = this.data.properties;
        label = po.svg('text');
        el.addSVGClass('nhood');
        el.mouseover(function() {
          return el.addSVGClass('over');
        });
        el.mouseout(function() {
          return el.removeSVGClass('over');
        });
        return el.bind('click', {
          props: props,
          geo: this.data.geometry
        }, function(event) {
          return document.location = "/neighborhoods/" + event.data.props.permalink;
        });
      });
    };
  });
}).call(this);
