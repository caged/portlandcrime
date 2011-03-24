/* DO NOT MODIFY. This file was compiled Wed, 23 Mar 2011 16:40:13 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/trends.coffee
 */

(function() {
  $(function() {
    if ($('body[data-path=trends-index]').length !== 0) {
      return $.getJSON('/trends.json', function(data) {
        var bars, curYear, h, layers, mlabels, months, nweeks, p, rules, vis, w, weeks, wmax, x0, x1, y;
        weeks = data[0], months = data[1];
        mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        curYear = new Date().getUTCFullYear();
        p = 20;
        nweeks = weeks[0].values.length;
        w = $('#trends').width() - p * 10;
        h = 200 - p;
        wmax = d3.max(weeks, function(d) {
          return d3.max(d.values, function(e) {
            return e.value;
          });
        });
        x0 = d3.scale.ordinal().domain(d3.range(nweeks)).rangeBands([0, w], 0.5);
        x1 = d3.scale.ordinal().domain(d3.range(nweeks)).rangeBands([0, x0.rangeBand()]);
        y = d3.scale.linear().domain([0, wmax]).range([0, h]);
        vis = d3.select('#weekly').append('svg:svg').attr('width', w + p).attr('height', h);
        rules = vis.selectAll('g.rule').data(d3.range(wmax)).enter().append("svg:g").attr("class", "rule");
        rules.append('svg:line').attr("y1", y).attr("y2", y).attr("x1", 0).attr("x2", w + 1);
        layers = vis.selectAll('g.layer').data(weeks).enter().append('svg:g').attr('class', 'layer').attr('transform', function(d, i) {
          return "translate(" + (x1(i)) + ",0)";
        }).attr('fill', function(d) {
          if (d.series === 'prev') {
            return '#00b2ec';
          } else {
            return '#cccccc';
          }
        });
        bars = layers.selectAll('g.bar').data(function(d) {
          return d.values;
        }).enter().append('svg:g').attr('class', 'bar').attr('transform', function(d, i) {
          return "translate(" + (x0(d.week)) + ",0)";
        });
        bars.append('svg:rect').attr('width', 3).attr('x', 0).attr('y', function(d) {
          return h - y(d.value);
        }).attr('height', function(d) {
          return y(d.value);
        });
        return vis.selectAll('text').data(weeks[0].values).enter().append('svg:text').attr("transform", function(d, i) {
          return "translate(" + (x0(i)) + ",0)";
        }).attr("text-anchor", "bottom").text(function(d) {
          return d.week;
        });
      });
    }
  });
}).call(this);
