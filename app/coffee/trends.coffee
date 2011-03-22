$ ->
  if $('body[data-path=trends-index]').length != 0
    $.getJSON '/trends.json', (data) ->
      [weeks, months] = data
      mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      curYear = new Date().getUTCFullYear()
      p = 20
      w = $('#trends').width() - .5 - p
      h = 200 - .5 - p
      wmax = d3.max weeks, (d) -> d3.max d.values, (e) -> e.value
      x0 = d3.scale.ordinal().domain(d3.range weeks[0].values.length).rangeBands [0, w], 0.5
      x1 = d3.scale.ordinal().domain(d3.range weeks[0].values.length).rangeBands [0, w], 0.5
      
      y = d3.scale.linear().domain([0, wmax]).range [0, h]
      
      vis = d3.select('#weekly')
        .append('svg:svg')
          .attr('width', w + p)
          .attr('height', h)
          
      layers = vis.selectAll('g.layer')
          .data(weeks)
        .enter().append('svg:g')
          .attr('class', 'layer')
          .attr('transform', (d, i) -> "translate(#{i * x.rangeBand()},0)")
          .attr('fill', (d) -> if d.series == 'prev' then '#00b2ec' else '#cccccc')
            
      bars = layers.selectAll('g.bar')
          .data((d)-> d.values)
        .enter().append('svg:g')
          .attr('class', 'bar')
          .attr('transform', (d) -> "translate(#{x(d.week)},0)")
      
      bars.append('svg:rect')
        .attr('width', 5)
        .attr('x', 0)
        .attr('y', (d) -> h - y d.value)
        .attr('height', (d) -> y d.value)
