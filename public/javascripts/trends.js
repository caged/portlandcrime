$(function() {
  if($('body[data-path=trends-index]').length != 0) {
    $.getJSON('/trends.json', function(data) {

      var ranges = ["prev", "curr"];
      
       var w = $('#trends').width() - 80,
           h = 250,
           x = pv.Scale.ordinal(data, function(d) { return d.week }).splitBanded(0, w),
           y = pv.Scale.linear(0, 2700).range(0, h),
           fill = pv.colors("lightgreen", "lightblue")

       var vis = new pv.Panel()
           .width(w)
           .height(h)
           .margin(19.5)
           .right(40)
           .canvas('trends')

       vis.add(pv.Layout.Stack)
           .layers(ranges)
           .values(data)
           .x(function(d) { return x(d.week) })
           .y(function(d, t) { return y(d[t]) })
         .layer.add(pv.Bar)
           .antialias(false)
           .width(x.range().band)
           .fillStyle(fill.by(pv.parent))
           .strokeStyle(function() { return this.fillStyle().darker() })
           .lineWidth(1)
         .anchor("bottom").add(pv.Label)
           .visible(function() { return !this.parent.index && !(this.index % 3) })
           .textBaseline("top")
           .textMargin(5)
           .text(function(d) { return d.week });

       vis.add(pv.Rule)
           .data(y.ticks(5))
           .bottom(y)
           .strokeStyle(function(i) { return i ? "rgba(100, 100, 100, .1)" : "#999" })
         .anchor("right").add(pv.Label)
           .textMargin(6);

       vis.render();
    })
  }
})