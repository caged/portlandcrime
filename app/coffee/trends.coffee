$ ->
  if $('body[data-path=trends-index]').length != 0
    $.getJSON '/trends.json', (data) ->
      [weeks, months] = data
      mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      curYear = new Date().getUTCFullYear()
      p = 20
      nweeks = weeks[0].values.length
      w = $('#trends').width() -  p * 10
      h = 200 -  p
      wmax = d3.max weeks, (d) -> d3.max d.values, (e) -> e.value
      x0 = d3.scale.ordinal().domain(d3.range nweeks).rangeBands [0, w], 0.5
      x1 = d3.scale.ordinal().domain(d3.range nweeks).rangeBands [0, x0.rangeBand()]
      y = d3.scale.linear().domain([0, wmax]).range [0, h]
      
      vis = d3.select('#weekly')
        .append('svg:svg')
          .attr('width', w + p)
          .attr('height', h)
      
      # rules = vis.selectAll('g.rule')
      #     .data()
      #   .enter().append("svg:g")
      #     .attr("class", "rule")
      #   
      # rules.append('svg:line')
      #   .attr("y1", y)
      #   .attr("y2", y)
      #   .attr("x1", 0)
      #   .attr("x2", w + 1);
          
      layers = vis.selectAll('g.layer')
          .data(weeks)
        .enter().append('svg:g')
          .attr('class', 'layer')
          .attr('transform', (d, i) -> "translate(#{x1(i)},0)")
          .attr('fill', (d) -> if d.series == 'prev' then '#00b2ec' else '#cccccc')
            
      bars = layers.selectAll('g.bar')
          .data((d)-> d.values)
        .enter().append('svg:g')
          .attr('class', 'bar')
          .attr('transform', (d, i) ->  "translate(#{x0 d.week},0)")
      
      bars.append('svg:rect')
        .attr('width', 3)
        .attr('x', 0)
        .attr('y', (d) -> h - y d.value)
        .attr('height', (d) -> y d.value)
        
      vis.selectAll('text')
        .data(weeks[0].values)
      .enter().append('svg:text')
        .attr("transform", (d, i) -> "translate(#{x0(i)},0)")
        .attr("text-anchor", "bottom")
        .text((d)-> d.week)