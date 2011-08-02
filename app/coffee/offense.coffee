$ ->
  return if $('body[data-path=offenses-show]').length == 0
  offense = $('#main').data 'permalink'
  mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  
  $.getJSON "/offenses/#{offense}/history.json", (d) ->
    
    [pl, pr, pt, pb] = [40, 20, 30, 30]
    w = $('#history-canvas').width() - (pl + pr)
    h = 200 - (pt + pb)
        
    x = d3.scale.linear().domain([0, d.length - 1]).range [0, w]
    y = d3.scale.linear().domain([0, d3.max(d, (o) -> o.count)]).range [h, 0]
    
    vis = d3.select('#history-canvas')
        .data([d])
      .append('svg:svg')
        .attr('width', w + (pl + pr))
        .attr('height', h + pt + pb)
        .attr('class', 'viz')
        .append('svg:g')
          .attr('transform', "translate(#{pl},#{pt})")
   
   
    xrules = vis.selectAll('g.xrule')
      .data(d)
    .enter().append('svg:g')
      .attr('class', 'rule')
        
    xrules.append('svg:line')
      .attr('class', (o, i) -> 'hide' if i in [0, d.length - 1] )
      .attr('x1', (d, i) -> x(i))
      .attr('x2', (d, i) -> x(i))
      .attr('y1', 0)
      .attr('y2', h - 1)
    
    xrules.append('svg:text')
      .attr('x', (d, i) -> x(i))
      .attr('y', h + 15)
      .attr('text-anchor', 'middle')
      .text((d) -> Date.parse(d.date).toString('MM/yy'))
      .attr('class', (d, i) -> 'hide' if i % 2 == 0)
      
    yrules = vis.selectAll('g.yrule')
      .data(y.ticks(5))
    .enter().append('svg:g')
      .attr('class', 'rule')

    yrules.append('svg:line')
      .attr('class', (d, i) -> 'hide' if i == 0)
      .attr('x1', 0)
      .attr('x2', w + 1)
      .attr('y1', y)
      .attr('y2', y)
    
    yrules.append("svg:text")
      .attr('class', (d, i) -> 'hide' if i == 0)
      .attr("y", y)
      .attr("x", -5)
      .attr("dy", ".35em")
      .attr("text-anchor", "end")
      .text(y.tickFormat(5))
                
    vis.append("svg:path")
      .attr("class", (d) -> 'area')
      .attr "d", d3.svg.area()
        .x((d,i) -> x(i))
        .y0((d) -> h)
        .y1((d) -> y(d.count))
        .interpolate('cardinal')
        .tension(.7)
        
    vis.append("svg:path")
      .attr("class", (d) -> 'apath')
      .attr "d", d3.svg.line()
        .x((d,i) -> x(i))
        .y((d) -> y(d.count))
        .interpolate('cardinal')
        .tension(.7)
        
    vis.selectAll("circle.area")
        .data(d)
      .enter().append("svg:circle")
        .attr("class", "point")
        .attr("cx", (d, i) -> x(i))
        .attr("cy", (d) -> y(d.count))
        .attr("r", 3)
      .append('svg:title')
        .text((d) -> d.count)