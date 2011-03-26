window.sparkline = (el, data, dots) ->
  n = data.length
  [pt,pl,pb,pr] = [20,5,5,10]
  w = $(el).width()
  h = 60 - pt - pb
  m = d3.max(data)
  x = d3.scale.linear().domain([0, n - 1]).range [0, w]
  y = d3.scale.linear().domain([0, m]).range [h, 0]
  
  vis = d3.select(el)
      .data([data])
    .append('svg:svg')
      .attr('width', w + pl - pr)
      .attr('height', h + pt + pb)
      .append('svg:g')
        .attr('transform', "translate(#{pl},#{pt})")
  
  vis.append("svg:path")
    .attr("class", (d) -> 'path')
    .attr "d", d3.svg.line()
      .x((d,i) -> x(i))
      .y((d) -> y(d))
      .interpolate('cardinal')
      .tension(.8)
  
  g = vis.selectAll('g.circle')
    .data((d) -> d)
  .enter().append('svg:g')
    .attr('transform', (d,i) -> "translate(#{x(i)},0)")
    
  g.append('svg:circle')
    .attr('r', 2)
    .attr('cx', 0)
    .attr('cy', -1.5)
    .attr('class', (d) -> if dots and d == m then 'dot max' else 'dot hide')
  
  g.append('svg:text')
    .attr('class', (d) -> if d != m then 'hide')
    .attr('text-anchor', 'middle')
    .attr('y', -8)
    .text((d) -> d)