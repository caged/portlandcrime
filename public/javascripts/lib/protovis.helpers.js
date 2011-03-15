function sparkline(el, data, dots) {
  var n = data.length,
      w = $(el).width(),
      h = 50,
      dmax = pv.max(data),
      x  = pv.Scale.linear(0, n - 1).range(0, w).by(pv.index),
      y  = pv.Scale.linear(data).range(0, h)

  var vis = new pv.Panel()
      .width(w + 6)
      .height(h + 3)
      .bottom(10)
      .left(4)
      .right(10)
      .top(10)
      .canvas(el.replace('#', ''));

          
  vis.add(pv.Line)
      .data(data)
      .left(x)
      .bottom(y)
      .strokeStyle("#52779E")
      .lineWidth(2)
      .interpolate('cardinal')
      .tension(0.8)
    .add(pv.Dot)
      .visible(function(d) { return dots && d == dmax })
      .fillStyle("#900")
      .strokeStyle('transparent')
      .radius(3)
    .add(pv.Label)
      .textStyle('#aaa')
      .visible(function(d) { return d == dmax })

  vis.render();
}