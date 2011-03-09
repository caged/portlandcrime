class Crime
  def self.ytd_weekly_totals
    weekly_totals_between(Time.now.beginning_of_year)
  end
  
  def self.monthly_totals_between(start, finish = Time.now)
    map = "function() { 
      var ra = this.reported_at;
      emit({month: ra.getMonth(), year: ra.getFullYear()}, {count:1, date: ra}) 
    }"
    Crime.collection.map_reduce(map, simple_date_reduce, 
      :query => {
        :reported_at => {
          '$lt' => finish, 
          '$gte' => start
        }}, :out => 'monthly_citywide_totals_report_' + start.year.to_s)
  end
  
  def self.weekly_totals_between(start, finish = Time.now)
    map = "function() { 
      var week = getWeek(this.reported_at)
      emit({week: week, year: this.reported_at.getFullYear()}, {count:1, date: this.reported_at}) 
    }"

    Crime.collection.map_reduce(map, simple_date_reduce, 
      :query => {:reported_at => {
        '$lt' => finish, 
        '$gte' => start
      }}, :out => 'weekly_citywide_totals_report_' + start.year.to_s)
  end
  
  private
  def self.simple_date_reduce
    <<-JS
      function(key, vals) {
        var sum = 0
        vals.forEach(function(val) { sum += val.count })
        return {count: sum, date: vals[0].date }
      }
    JS
  end
end