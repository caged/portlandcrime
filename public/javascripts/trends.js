/* DO NOT MODIFY. This file was compiled Tue, 22 Mar 2011 08:41:23 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/trends.coffee
 */

(function() {
  $(function() {
    if ($('body[data-path=trends-index]').length !== 0) {
      return $.getJSON('/trends.json', function(data) {
        var bars, cmax, curYear, h, layers, max, mlabels, months, pmax, ranges, vis, w, weeks, x;
        ranges = ['prev', 'curr'];
        weeks = data[0], months = data[1];
        mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        curYear = new Date().getUTCFullYear();
        w = $('#trends').width() - 70;
        h = 200;
        pmax = d3.max(weeks, function(d) {
          return d.prev;
        });
        cmax = d3.max(weeks, function(d) {
          return d.curr;
        });
        max = d3.max([pmax, cmax], x = function(d) {
          return d.x * w / weeks.length;
        });
        vis = d3.select('#weekly').append('svg:svg').attr('width', w).attr('height', h).data(data);
        layers = vis.selectAll('g.layer').data(ranges).enter().append('svg:g').attr('class', 'layer');
        bars = layers.selectAll('g.bar').enter().append('svg:g').attr('fill', "rgb(30,30,30)").attr('class', 'bar').attr('transform', function(t, d) {
          console.log(arguments);
          return "translate(" + (x(d)) + ")";
        });
        return bars.append('svg:rect').attr('width', x({
          x: 0.9
        })).attr('x', 0).attr('h', h);
      });
    }
  });
}).call(this);
