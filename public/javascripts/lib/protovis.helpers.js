function sparkline(el, data, dots) {
  var n = data.length,
      w = $(el).width(),
      h = 30,
      min = pv.min.index(data),
      max = pv.max.index(data);

  var vis = new pv.Panel()
      .width(w + 6)
      .height(h + 3)
      .margin(2)
      .canvas(el.replace('#', ''));

  vis.add(pv.Line)
      .data(data)
      .left(pv.Scale.linear(0, n - 1).range(0, w).by(pv.index))
      .bottom(pv.Scale.linear(data).range(0, h))
      .strokeStyle("#aaa")
      .lineWidth(2)
    .add(pv.Dot)
      .visible(function() { return (dots && this.index == 0) || this.index == n - 1 })
      .strokeStyle(null)
      .fillStyle("#999")
      .radius(3)
    .add(pv.Dot)
      .visible(function() { return dots && (this.index == min || this.index == max) })
      .fillStyle("#6db963");

  vis.render();
}