/* DO NOT MODIFY. This file was compiled Tue, 22 Mar 2011 20:45:28 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/trends.coffee
 */

(function() {
  $(function() {
    if ($('body[data-path=trends-index]').length !== 0) {
      return $.getJSON('/trends.json', function(data) {
        var bars, curYear, h, layers, mlabels, months, p, vis, w, weeks, wmax, x, y;
        weeks = data[0], months = data[1];
        mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        curYear = new Date().getUTCFullYear();
        p = 20;
        w = $('#trends').width() - .5 - p;
        h = 200 - .5 - p;
        wmax = d3.max(weeks, function(d) {
          return d3.max(d.values, function(e) {
            return e.value;
          });
        });
        x = d3.scale.ordinal().domain(d3.range(weeks[0].values.length)).rangeBands([0, w], 0.5);
        y = d3.scale.linear().domain([0, wmax]).range([0, h]);
        vis = d3.select('#weekly').append('svg:svg').attr('width', w + p).attr('height', h);
        layers = vis.selectAll('g.layer').data(weeks).enter().append('svg:g').attr('class', 'layer').attr('transform', function(d, i) {
          return "translate(" + (i * x.rangeBand()) + ",0)";
        }).attr('fill', function(d) {
          if (d.series === 'prev') {
            return '#00b2ec';
          } else {
            return '#cccccc';
          }
        });
        bars = layers.selectAll('g.bar').data(function(d) {
          return d.values;
        }).enter().append('svg:g').attr('class', 'bar').attr('transform', function(d) {
          return "translate(" + (x(d.week)) + ",0)";
        });
        return bars.append('svg:rect').attr('width', 5).attr('x', 0).attr('y', function(d) {
          return h - y(d.value);
        }).attr('height', function(d) {
          return y(d.value);
        });
      });
    }
  });
}).call(this);
