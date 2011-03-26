/* DO NOT MODIFY. This file was compiled Sat, 26 Mar 2011 18:11:53 GMT from
 * /Users/justin/dev/lrr/rails/portlandcrime/app/coffee/trends.coffee
 */

(function() {
  $(function() {
    if ($('body[data-path=trends-index]').length !== 0) {
      return $.getJSON('/trends.json', function(data) {
        var drawTrend, h, lblwid, mlabels, months, pb, pl, pr, pt, w, weeks, year, _ref;
        weeks = data[0], months = data[1];
        mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        year = new Date().getUTCFullYear();
        _ref = [30, 30, 20, 40], pt = _ref[0], pl = _ref[1], pb = _ref[2], pr = _ref[3];
        lblwid = 60;
        w = $('#trends').width() - (pl + pr + 10);
        h = 230 - (pt + pb);
        drawTrend = function(el, data) {
          var g, labels, legend, rules, samples, vis, wmax, x, y0, y1;
          samples = data[0].values.length;
          wmax = d3.max(data, function(d) {
            return d3.max(d.values, function(e) {
              return e.value;
            });
          });
          x = d3.scale.linear().domain([0, wmax]).range([h, 0]);
          y0 = d3.scale.ordinal().domain(d3.range(samples)).rangeBands([0, w], 0.5);
          y1 = d3.scale.ordinal().domain(d3.range(2)).rangeBands([0, y0.rangeBand()]);
          labels = el === '#monthly' ? mlabels : d3.range(samples);
          vis = d3.select(el).append('svg:svg').attr('width', w + (pl + pr)).attr('height', h + pt + pb).attr('class', 'viz').append('svg:g').attr('transform', "translate(" + pl + "," + pt + ")");
          g = vis.selectAll('g.bar').data(data).enter().append('svg:g').attr('fill', function(d) {
            if (d.series === 'prev') {
              return '#cccccc';
            } else {
              return '#00b2ec';
            }
          }).attr('transform', function(d, i) {
            return "translate(" + (y1(i)) + ",0)";
          });
          g.selectAll('rect').data(function(d) {
            return d.values;
          }).enter().append('svg:rect').attr('transform', function(d, i) {
            return "translate(" + (y0(i) + 0.5) + ",0)";
          }).attr('width', y1.rangeBand() / 2).attr('height', function(d, i) {
            return h - x(d.value);
          }).attr('y', function(d) {
            return x(d.value);
          });
          rules = vis.selectAll('g.rule').data(function(d) {
            if (el !== '#monthly') {
              return x.ticks(10);
            } else {
              return x.ticks(4);
            }
          }).enter().append('svg:g').attr('class', function(d) {
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
          vis.selectAll('h.text').data(labels).enter().append('svg:text').attr('class', function(d, i) {
            if (i % 3 !== 0 && el !== '#monthly') {
              return 'hlbl hide';
            } else {
              return 'hlbl';
            }
          }).attr("transform", function(d, i) {
            return "translate(" + (y0(i)) + ",0)";
          }).attr("x", y0.rangeBand() / 2).attr("y", h + 12).attr("text-anchor", "middle").text(function(d) {
            if (el !== '#monthly') {
              return d + 1;
            } else {
              return d;
            }
          });
          legend = vis.selectAll('legend').data([year - 1, year]);
          legend.enter().append('svg:circle').attr('transform', "translate(" + ((w - (lblwid * 2)) / 2) + ", -10)").attr('cx', function(d, i) {
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
          return legend.enter().append('svg:text').attr('transform', "translate(" + ((w - (lblwid * 2)) / 2) + ", -10)").attr("x", function(d, i) {
            return 10 + (lblwid * i);
          }).attr('y', 5).attr('class', 'legend').text(function(d) {
            return d;
          });
        };
        drawTrend('#weekly', weeks);
        return $(document).bind('tab.clicked', function(event, el) {
          var hdr, sel;
          el = $(el);
          sel = $('li a.current').attr('href');
          hdr = el.prev('h1');
          if (sel === '#monthly') {
            return hdr.text('Weekly Trend');
          } else {
            hdr.text('Monthly Trend');
            if ($('#monthly svg').length === 0) {
              return drawTrend('#monthly', months);
            }
          }
        });
      });
    }
  });
}).call(this);
