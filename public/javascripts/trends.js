$(function() {
  if($('body[data-path=trends-index]').length != 0) {
    $.getJSON('/trends.json', function(data) {      
      var ranges = ["prev", "curr"],
          months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      
      var w = $('#trends').width() - 70,
          h = 200,
          x = pv.Scale.ordinal(data, function(d) { return d.week }).splitBanded(0, w, 4 / 5),
          y = pv.Scale.linear(0, 1400).range(0, h),
          k = x.range().band / ranges.length

      var vis = new pv.Panel()
          .width(w)
          .height(h)
          .margin(20)
          .top(40)
          .right(40)
          .canvas('trends')

      var panel = vis.add(pv.Panel)
          .data(data)
          .left(function(d) { return x(d.week) })
          .width(x.range().band);

      panel.add(pv.Bar)
          .data(ranges)
          .bottom(0)
          .width(k - 2)
          .left(function() { return this.index * k })
          .height(function(t, d) { return y(d[t]) })
          .fillStyle(pv.colors("#ccc", "#00b2ec"))
          .lineWidth(1);

      // panel.anchor("bottom").add(pv.Label)
      //     .visible(function(d) { return !(this.parent.index % 4) || d.week != 0 })
      //     .textBaseline("top")
      //     .textMargin(15)
      //     .textAlign('left')
      //     .text(function(d) { 
      //       if(this.parent.index != 0)
      //         return months[(this.parent.index / 4) - 1]  
      //     });
          
      panel.anchor("bottom").add(pv.Label)
          .visible(function() { return !(this.parent.index % 3) })
          .textBaseline("top")
          .textMargin(5)
          .text(function(d) { return d.week });
          
      vis.add(pv.Dot) 
            .data(['2009', '2010']) 
            .top(-20) 
            .left(function() { return 360 + this.index * 65 }) 
            .size(30) 
            .strokeStyle(null)
            .fillStyle(pv.colors('#ccc', '#00b2ec')) 
          .anchor("right").add(pv.Label)
            .top(-19)
            .left(function() { return 365 + this.index * 65 })
            .font("bold 14px 'Helvetica Neue', sans-serif")
            .textStyle('#444');

      vis.add(pv.Rule)
          .data(y.ticks())
          .bottom(y)
          .strokeStyle(function(i) { return i ? "rgba(100, 100, 100, .1)" : "#ccc" })
        .anchor("right").add(pv.Label)
          .visible(function() { return !(this.index & 1) })
          .textMargin(6);

      vis.render();
    })
  }
})