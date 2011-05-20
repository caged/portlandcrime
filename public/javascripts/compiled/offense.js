/* DO NOT MODIFY. This file was compiled Fri, 20 May 2011 19:46:35 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/offense.coffee
 */

(function() {
  $(function() {
    var mlabels, offense;
    offense = $('#main').data('permalink');
    mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return $.getJSON("/offenses/" + offense + "/history.json", function(d) {
      var h, pb, pl, pr, pt, vis, w, x, xrules, y, yrules, _ref;
      _ref = [40, 20, 30, 30], pl = _ref[0], pr = _ref[1], pt = _ref[2], pb = _ref[3];
      w = $('#history-canvas').width() - (pl + pr);
      h = 200 - (pt + pb);
      x = d3.scale.linear().domain([0, d.length - 1]).range([0, w]);
      y = d3.scale.linear().domain([
        0, d3.max(d, function(o) {
          return o.count;
        })
      ]).range([h, 0]);
      vis = d3.select('#history-canvas').data([d]).append('svg:svg').attr('width', w + (pl + pr)).attr('height', h + pt + pb).attr('class', 'viz').append('svg:g').attr('transform', "translate(" + pl + "," + pt + ")");
      xrules = vis.selectAll('g.xrule').data(d).enter().append('svg:g').attr('class', 'rule');
      xrules.append('svg:line').attr('class', function(o, i) {
        if (i === 0 || i === d.length - 1) {
          return 'hide';
        }
      }).attr('x1', function(d, i) {
        return x(i);
      }).attr('x2', function(d, i) {
        return x(i);
      }).attr('y1', 0).attr('y2', h - 1);
      xrules.append('svg:text').attr('x', function(d, i) {
        return x(i);
      }).attr('y', h + 15).attr('text-anchor', 'middle').text(function(d) {
        return Date.parse(d.date).toString('MM/yy');
      }).attr('class', function(d, i) {
        if (i % 2 === 0) {
          return 'hide';
        }
      });
      yrules = vis.selectAll('g.yrule').data(y.ticks(5)).enter().append('svg:g').attr('class', 'rule');
      yrules.append('svg:line').attr('class', function(d, i) {
        if (i === 0) {
          return 'hide';
        }
      }).attr('x1', 0).attr('x2', w + 1).attr('y1', y).attr('y2', y);
      yrules.append("svg:text").attr('class', function(d, i) {
        if (i === 0) {
          return 'hide';
        }
      }).attr("y", y).attr("x", -5).attr("dy", ".35em").attr("text-anchor", "end").text(y.tickFormat(5));
      vis.append("svg:path").attr("class", function(d) {
        return 'area';
      }).attr("d", d3.svg.area().x(function(d, i) {
        return x(i);
      }).y0(function(d) {
        return h;
      }).y1(function(d) {
        return y(d.count);
      }).interpolate('cardinal').tension(.7));
      vis.append("svg:path").attr("class", function(d) {
        return 'apath';
      }).attr("d", d3.svg.line().x(function(d, i) {
        return x(i);
      }).y(function(d) {
        return y(d.count);
      }).interpolate('cardinal').tension(.7));
      return vis.selectAll("circle.area").data(d).enter().append("svg:circle").attr("class", "point").attr("cx", function(d, i) {
        return x(i);
      }).attr("cy", function(d) {
        return y(d.count);
      }).attr("r", 3).append('svg:title').text(function(d) {
        return d.count;
      });
    });
  });
}).call(this);
