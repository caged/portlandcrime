$ ->
  if $('body[data-path=trends-index]').length != 0
    $.getJSON '/trends.json', (data) ->
      [weeks, months] = data
      mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      year    = new Date().getUTCFullYear()
      nweeks  = weeks[0].values.length
      ptop    = 20
      pbot    = 30
      pleft   = 20
      pright  = 40
      lblwid  = 60
      w       = $('#trends').width() - (pleft + pright + 10)
      h       = 200 - (ptop + pbot)
      wmax    = d3.max weeks, (d) -> d3.max d.values, (e) -> e.value
      x       = d3.scale.linear().domain([0, wmax]).range [h,0]
      y0      = d3.scale.ordinal().domain(d3.range nweeks).rangeBands [0, w], 0.5
      y1      = d3.scale.ordinal().domain(d3.range 2).rangeBands [0, y0.rangeBand()]
      
      vis = d3.select('#weekly')
        .append('svg:svg')
          .attr('width', w + (pleft + pright))
          .attr('height', h + ptop + pbot)
          .append('svg:g')
            .attr('transform', "translate(#{pleft},#{ptop})")
      
      rules = vis.selectAll('g.rule')
          .data(x.ticks(10))
        .enter().append('svg:g')
          .attr('class', (d) -> if d then null else 'axis')
          
      rules.append('svg:line')
        .attr("y1", x)
        .attr("y2", x)
        .attr("x1", 0)
        .attr("x2", w)
        
      rules.append('svg:text')
        .attr('y', x)
        .attr("dy", ".2em")
        .attr('x', w + 5)
        .attr('class', 'vlbl')
        .text((d) -> d)
      
      vis.selectAll('h.text')
        .data(d3.range(nweeks))
      .enter().append('svg:text')
        .attr('class', (d, i) -> if i % 3 == 0 then 'hlbl' else 'hlbl hide')
        .attr("transform", (d, i) -> "translate(#{y0(i)},0)")
        .attr("x", y0.rangeBand() / 2)
        .attr("y", h + 12)
        .attr("text-anchor", "middle")
        .text((d)-> d + 1)
      
      g = vis.selectAll('g.bar')
          .data(weeks)
        .enter().append('svg:g')
          .attr('fill', (d) -> if d.series == 'prev' then '#00b2ec' else '#cccccc')
          .attr('transform', (d, i) -> "translate(#{y1(i)},0)")
      
      g.selectAll('rect')
        .data((d) -> d.values)
      .enter().append('svg:rect')
        .attr('transform', (d,i) -> "translate(#{y0(i)},0)")
        .attr('width', y1.rangeBand() / 1.5)
        .attr('height', (d,i) -> h - x(d.value))
        .attr('y', (d) -> x(d.value))
        
      legend = vis.selectAll('legend')
        .data([year - 1, year])
        
      legend.enter().append('svg:circle')
        .attr('transform', "translate(#{((w - (lblwid * 2)) / 2)}, 0)")
        .attr('cx', (d, i) -> lblwid * i)
        .attr('fill', (d) -> if d == year then '#00b2ec' else '#cccccc')
        .attr('r', 3)
        .text((d) -> d)
      
      legend.enter().append('svg:text')
        .attr('transform', "translate(#{((w - (lblwid * 2)) / 2)}, 0)")
        .attr("x", (d, i) -> 10 + (lblwid * i))
        .attr('y', 5)
        .attr('class', 'legend')
        .text((d) -> d)
        
        
        # vis.add(pv.Dot) 
        #       .data([curYear - 1, curYear]) 
        #       .top(-20) 
        #       .left(function() { return 360 + this.index * 65 }) 
        #       .size(30) 
        #       .strokeStyle(null)
        #       .fillStyle(pv.colors('#ccc', '#00b2ec')) 
        #     .anchor("right").add(pv.Label)
        #       .top(-19)
        #       .left(function() { return 365 + this.index * 65 })
        #       .font("bold 14px 'Helvetica Neue', sans-serif")
        #       .textStyle('#444');