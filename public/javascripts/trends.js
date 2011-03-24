/* DO NOT MODIFY. This file was compiled Thu, 24 Mar 2011 19:20:28 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/trends.coffee
 */

(function() {
  $(function() {
    if ($('body[data-path=trends-index]').length !== 0) {
      return $.getJSON('/trends.json', function(data) {
        var curYear, g, h, mlabels, months, nweeks, pbot, pleft, pright, ptop, rules, vis, w, weeks, wmax, x, y0, y1;
        weeks = data[0], months = data[1];
        mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        curYear = new Date().getUTCFullYear();
        nweeks = weeks[0].values.length;
        ptop = 10;
        pbot = 20;
        pleft = 10;
        pright = 30;
        w = $('#trends').width() - (pleft + pright);
        h = 200 - (ptop + pbot);
        wmax = d3.max(weeks, function(d) {
          return d3.max(d.values, function(e) {
            return e.value;
          });
        });
        x = d3.scale.linear().domain([0, wmax]).range([h, 0]);
        y0 = d3.scale.ordinal().domain(d3.range(nweeks)).rangeBands([0, w], 0.5);
        y1 = d3.scale.ordinal().domain(d3.range(2)).rangeBands([0, y0.rangeBand()]);
        vis = d3.select('#weekly').append('svg:svg').attr('width', w + (pleft + pright)).attr('height', h + ptop + pbot).append('svg:g').attr('transform', "translate(" + pleft + "," + ptop + ")");
        rules = vis.selectAll('g.rule').data(x.ticks(12)).enter().append('svg:g').attr('class', function(d) {
          if (d) {
            return null;
          } else {
            return 'axis';
          }
        });
        rules.append('svg:line').attr("y1", x).attr("y2", x).attr("x1", 0).attr("x2", w + 1);
        g = vis.selectAll('g.bar').data(weeks).enter().append('svg:g').attr('fill', function(d) {
          if (d.series === 'prev') {
            return '#00b2ec';
          } else {
            return '#cccccc';
          }
        }).attr('transform', function(d, i) {
          return "translate(" + (y1(i)) + ",0)";
        });
        g.selectAll('rect').data(function(d) {
          return d.values;
        }).enter().append('svg:rect').attr('transform', function(d, i) {
          return "translate(" + (y0(i)) + ",0)";
        }).attr('width', y1.rangeBand()).attr('height', function(d, i) {
          return h - x(d.value);
        }).attr('y', function(d) {
          return x(d.value);
        });
        return vis.selectAll('text').data(d3.range(nweeks)).enter().append('svg:text').attr('class', function(d, i) {
          if (i % 3 === 0) {
            return 'hlbl';
          } else {
            return 'hlbl hide';
          }
        }).attr("transform", function(d, i) {
          return "translate(" + (y0(i)) + ",0)";
        }).attr("x", y0.rangeBand() / 2).attr("y", h + 12).attr("text-anchor", "middle").text(function(d) {
          return d + 1;
        });
      });
    }
  });
}).call(this);
