class Crime
  def self.weekly_totals_from_now
    weekly_totals_from(Time.now.beginning_of_year)
  end
  
  def self.weekly_totals_from(start)
    map = "function() { 
      var week = getWeek(this.reported_at)
      if(week == 53.0)  {
        print(this.reported_at)
        week = 0
      }
      emit(week, {count:1, date: this.reported_at}) 
    }"
    red = <<-JS
      function(key, vals) {
        var sum = 0
        vals.forEach(function(val) { sum += val.count })
        return {count: sum, date: vals[0].date }
      }
    JS
    Crime.collection.map_reduce(map, red, 
      :query => {:reported_at => {
        '$lt' => Time.now, 
        '$gte' => start
      }}, :out => 'weekly_citywide_totals_report_' + start.year.to_s)
  end
end