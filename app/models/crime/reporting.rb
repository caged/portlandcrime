class Crime
  def self.monthly_totals_from_now
    monthly_totals_from(Time.now.beginning_of_year)
  end
  
  def self.monthly_totals_from(start)
    map = "function() { 
      var month = this.reported_at.getMonth() + 1 + '/' + this.reported_at.getFullYear()
      emit(month, 1) 
    }"
    red = <<-JS
      function(key, vals) {
        var sum = 0
        vals.forEach(function(val) { sum += val })
        return sum
      }
    JS
    Crime.collection.map_reduce(map, red, 
      :query => {:reported_at => {
        '$lt' => Time.now, 
        '$gte' => start
      }}, :out => 'monthly_citywide_totals_report_' + start.year.to_s)
  end
end