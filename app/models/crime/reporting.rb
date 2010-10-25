class Crime
  def self.weekly_totals_from_now
    weekly_totals_from(Time.now.beginning_of_year)
  end
  
  def self.weekly_totals_from(start)
    map = "function() { 
      var weekOfMonth = Math.round(this.reported_at.getDate() / 7) + 1
      
      emit(this.reported_at.getMonth() + '/' + 
        this.reported_at.getFullYear() + ' Week ' + 
        weekOfMonth, 
        {count:1, date: this.reported_at}) 
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