$ ->
  if $('body[data-path=trends-index]').length != 0
    $.getJSON '/trends.json', (data) ->
      ranges = ['prev', 'curr']
      [weeks, months] = data
      mlabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      curYear = new Date().getUTCFullYear()
      
      w = $('#trends').width() - 70
      h = 200
      pmax = d3.max weeks, (d) -> d.prev 
      cmax = d3.max weeks, (d) -> d.curr
      max  = d3.max [pmax, cmax],
      x = (d) -> d.x * w / weeks.length
      #x = d3.scale.ordinal(weeks, (d) -> d.week).splitBanded 0, w, 0.6
      # cmax = pv.max(weeks, function(d) { return d.curr })
      # max  = pv.max([pmax, cmax])
      # x = pv.Scale.ordinal(weeks, function(d) { return d.week }).splitBanded(0, w, 0.6)
      # y = pv.Scale.linear(0, max).range(0, h)
      # k = x.range().band / ranges.length
      
      vis = d3.select('#weekly')
        .append('svg:svg')
          .attr('width', w)
          .attr('height', h)
          .data(data)
          
      layers = vis.selectAll('g.layer')
          .data(ranges)
        .enter().append('svg:g')
          .attr('class', 'layer')
            
      bars = layers.selectAll('g.bar')
          .data((d)-> d)
        .enter().append('svg:g')
          .attr('fill', "rgb(30,30,30)")
          .attr('class', 'bar')
          .attr('transform', (t, d) -> console.log arguments; "translate(#{x(d)})")
      
      bars.append('svg:rect')
        .attr('width', x({x: 0.9}))
        .attr('x', 0)
        .attr('h', h)