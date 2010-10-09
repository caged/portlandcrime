$(function() {
  var types = {
    'violent':          '#B50000',
    'non-violent':      '#3E3095',
    'drugs & alchohol': '#BDB62C',
    'financial':        '#00B93F',
    'sexual':           '#FF00A4'
  }
  return
  $.getJSON('/tmp.json', function(crimes) {
    var start = Date.parse(crimes[0].date.split('T')[0])
    var end = Date.parse(crimes[crimes.length - 1].date.split('T')[0])
    // 
    // var counts = {}
    // $.each(crimes, function(idx, cr) {
    //   var d = cr.date.split('T')[0]
    //   counts[d] = counts[d] || { date: Date.parse(d), num: 0 }
    //   counts[d].num++
    // })
    // 
    // var data = []
    // $.each(counts, function(k, v) {
    //   data.push(v) 
    // })
    // 
     // var data = pv.range(1).map(function() {
     // 
     //   });
     
    var dates = pv.range(start.getTime(), end.getTime(), 86400000);
    // 
    // var data = [
    //   [
    //     {date: new Date('01/01/2010'), num: 32},
    //     {date: new Date('01/02/2010'), num: 12},
    //     {date: new Date('01/03/2010'), num: 15},
    //     {date: new Date('01/04/2010'), num: 28},
    //     {date: new Date('01/05/2010'), num: 65}
    //   ],                      
    //   [                       
    //     {date: new Date('01/01/2010'), num: 12},
    //     {date: new Date('01/02/2010'), num: 15},
    //     {date: new Date('01/03/2010'), num: 42},
    //     {date: new Date('01/04/2010'), num: 16},
    //     {date: new Date('01/05/2010'), num: 21}
    //   ]
    // ]
    
    dates.each(function() {
      console.log(this); 
    })
       
     /* Sizing and scales. */
     var w = $('#history').width(),
         h = 200,
         x = pv.Scale.linear(0, end.getTime()).range(0, w),
         y = pv.Scale.linear(0, function(d) { return d.num }).range(0, h);

     /* The root panel. */
     var vis = new pv.Panel()
         .width(w)
         .height(h)
         .left(0)
         .right(0)
         .bottom(20)
         .canvas('history')

     /* X-axis and ticks. */
     vis.add(pv.Rule)
         .data(x.ticks())
         .visible(function(d) { return d })
         .left(x)
         .bottom(-5)
         .height(5)
       .anchor("bottom").add(pv.Label)
         .text(x.tickFormat);

     /* The stack layout. */
     vis.add(pv.Layout.Stack)
         .layers(data)
         .x(function(d) { console.log(d.date); return x(d.date) })
         .y(function(d) { return y(d.num) })
       .layer.add(pv.Area);

     /* Y-axis and ticks. */
     vis.add(pv.Rule)
         .data(y.ticks(3))
         .bottom(y)
         .strokeStyle(function(d) { return d ? "rgba(128,128,128,.2)" : "#eee"})
       .anchor("left").add(pv.Label)
         .text(y.tickFormat);

     vis.render();
  })
})