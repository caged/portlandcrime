/* DO NOT MODIFY. This file was compiled Thu, 24 Mar 2011 20:10:28 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/trends.coffee
 */

(function() {
  $(function() {
    if ($('body[data-path=trends-index]').length !== 0) {
      return $.getJSON('/trends.json', function(data) {
        var g, h, lblwid, legend, mlabels, months, nweeks, pbot, pleft, pright, ptop, rules, vis, w, weeks, wmax, x, y0, y1, year;
        weeks = data[0], months = data[1];
        mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        year = new Date().getUTCFullYear();
        nweeks = weeks[0].values.length;
        ptop = 20;
        pbot = 30;
        pleft = 20;
        pright = 40;
        lblwid = 60;
        w = $('#trends').width() - (pleft + pright + 10);
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
        rules = vis.selectAll('g.rule').data(x.ticks(10)).enter().append('svg:g').attr('class', function(d) {
          if (d) {
            return null;
          } else {
            return 'axis';
          }
        });
        rules.append('svg:line').attr("y1", x).attr("y2", x).attr("x1", 0).attr("x2", w);
        rules.append('svg:text').attr('y', x).attr("dy", ".2em").attr('x', w + 5).attr('class', 'vlbl').text(function(d) {
          return d;
        });
        vis.selectAll('h.text').data(d3.range(nweeks)).enter().append('svg:text').attr('class', function(d, i) {
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
        }).attr('width', y1.rangeBand() / 1.5).attr('height', function(d, i) {
          return h - x(d.value);
        }).attr('y', function(d) {
          return x(d.value);
        });
        legend = vis.selectAll('legend').data([year - 1, year]);
        legend.enter().append('svg:circle').attr('transform', "translate(" + ((w - (lblwid * 2)) / 2) + ", 0)").attr('cx', function(d, i) {
          return lblwid * i;
        }).attr('fill', function(d) {
          if (d === year) {
            return '#00b2ec';
          } else {
            return '#cccccc';
          }
        }).attr('r', 3).text(function(d) {
          return d;
        });
        return legend.enter().append('svg:text').attr('transform', "translate(" + ((w - (lblwid * 2)) / 2) + ", 0)").attr("x", function(d, i) {
          return 10 + (lblwid * i);
        }).attr('y', 5).attr('class', 'legend').text(function(d) {
          return d;
        });
      });
    }
  });
}).call(this);
