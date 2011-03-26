/* DO NOT MODIFY. This file was compiled Sat, 26 Mar 2011 19:54:16 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/d3.stdlib.coffee
 */

(function() {
  window.sparkline = function(el, data, dots) {
    var g, h, m, n, pb, pl, pr, pt, vis, w, x, y, _ref;
    n = data.length;
    _ref = [20, 5, 5, 10], pt = _ref[0], pl = _ref[1], pb = _ref[2], pr = _ref[3];
    w = $(el).width();
    h = 60 - pt - pb;
    m = d3.max(data);
    x = d3.scale.linear().domain([0, n - 1]).range([0, w]);
    y = d3.scale.linear().domain([0, m]).range([h, 0]);
    vis = d3.select(el).data([data]).append('svg:svg').attr('width', w + pl - pr).attr('height', h + pt + pb).append('svg:g').attr('transform', "translate(" + pl + "," + pt + ")");
    vis.append("svg:path").attr("class", function(d) {
      return 'path';
    }).attr("d", d3.svg.line().x(function(d, i) {
      return x(i);
    }).y(function(d) {
      return y(d);
    }).interpolate('cardinal').tension(.8));
    g = vis.selectAll('g.circle').data(function(d) {
      return d;
    }).enter().append('svg:g').attr('transform', function(d, i) {
      return "translate(" + (x(i)) + ",0)";
    });
    g.append('svg:circle').attr('r', 2).attr('cx', 0).attr('cy', -1.5).attr('class', function(d) {
      if (dots && d === m) {
        return 'dot max';
      } else {
        return 'dot hide';
      }
    });
    return g.append('svg:text').attr('class', function(d) {
      if (d !== m) {
        return 'hide';
      }
    }).attr('text-anchor', 'middle').attr('y', -8).text(function(d) {
      return d;
    });
  };
}).call(this);
