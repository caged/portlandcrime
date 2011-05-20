$ ->
  if $('body[data-path=trends-index]').length != 0
    $.getJSON '/trends.json', (data) ->
      # Data
      [weeks, months] = data
      mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      year    = new Date().getUTCFullYear()
      
      # Demensions, Padding
      [pt,pl,pb,pr] = [30,30,20,40]
      lblwid  = 60
      w       = $('#trends').width() - (pl + pr + 10)
      h       = 230 - (pt + pb)
      
      drawTrend = (el, data) ->
        # Scales
        samples = data[0].values.length
        wmax    = d3.max data, (d) -> d3.max d.values, (e) -> e.value
        y       = d3.scale.linear().domain([0, wmax]).range [h,0]
        x0      = d3.scale.ordinal().domain(d3.range samples).rangeBands [0, w], 0.5
        x1      = d3.scale.ordinal().domain(d3.range 2).rangeRoundBands [0, x0.rangeBand()]
        labels  = if el == '#monthly' then mlabels else d3.range(samples)
      
        vis = d3.select(el)
          .append('svg:svg')
            .attr('width', w + (pl + pr))
            .attr('height', h + pt + pb)
            .attr('class', 'viz')
            .append('svg:g')
              .attr('transform', "translate(#{pl},#{pt})")
        
        rules = vis.selectAll('g.rule')
            .data((d) -> if el != '#monthly' then y.ticks(10) else y.ticks(4))
          .enter().append('svg:g')
            .attr('class', (d) -> if d then null else 'axis')
          
        rules.append('svg:line')
          .attr("y1", (d) -> Math.ceil(y(d)))
          .attr("y2", (d) -> Math.ceil(y(d)))
          .attr("x1", 0)
          .attr("x2", w)
        
        rules.append('svg:text')
          .attr('y', y)
          .attr("dy", ".2em")
          .attr('x', w + 5)
          .attr('class', 'vlbl')
          .text((d) -> d)
      
        vis.selectAll('h.text')
          .data(labels)
        .enter().append('svg:text')
          .attr('class', (d, i) -> if i % 2 != 0 && el != '#monthly' then 'hlbl hide' else 'hlbl')
          .attr("transform", (d, i) -> "translate(#{x0(i)},0)")
          .attr("x", x0.rangeBand())
          .attr("y", h + 12)
          .attr("text-anchor", "middle")
          .text((d)-> if el != '#monthly' then d + 1 else d)
        
        legend = vis.selectAll('legend')
          .data([year - 1, year])
        
        legend.enter().append('svg:circle')
          .attr('transform', "translate(#{((w - (lblwid * 2)) / 2)}, -10)")
          .attr('cx', (d, i) -> lblwid * i)
          .attr('fill', (d) -> if d == year then '#00b2ec' else '#cccccc')
          .attr('class', 'c')
          .attr('r', 4)
          .text((d) -> d)
      
        legend.enter().append('svg:text')
          .attr('transform', "translate(#{((w - (lblwid * 2)) / 2)}, -10)")
          .attr("x", (d, i) -> 10 + (lblwid * i))
          .attr('y', 5)
          .attr('class', 'legend')
          .text((d) -> d)
              
        g = vis.selectAll('g.bar')
            .data(data)
          .enter().append('svg:g')
            .attr('fill', (d) -> if d.series == 'prev' then '#cccccc' else '#00b2ec')
            .attr('transform', (d, i) -> "translate(#{x1(i)},0)")
    
        g.selectAll('rect')
          .data((d) -> d.values)
        .enter().append('svg:rect')
          .attr('transform', (d,i) -> "translate(#{x0(i) + x1.rangeBand()},0)")
          .attr('width', x1.rangeBand() / 2)
          .attr('height', (d,i) -> h - y(d.value))
          .attr('y', (d) -> y(d.value))
        
      drawTrend '#weekly', weeks
      $(document).bind 'tab.clicked', (event, el) ->
        el = $(el)
        sel = $('li a.current').attr 'href'
        hdr = el.prev 'h1'
        
        if sel == '#monthly'
          hdr.text 'Weekly Trend'
        else
          hdr.text 'Monthly Trend'
          if $('#monthly svg').length == 0
            drawTrend '#monthly', months