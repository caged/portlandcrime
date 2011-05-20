class Offense
  def self.hourly_summaries_between(start, finish)
    map = "function() { emit({offense: this.offense_id, hour: this.reported_at.getHours()}, 1) }"
    red = <<-JS
      function(key, vals) {
        var sum = 0
        vals.forEach(function(val, idx) {
          sum += val
        })
        
        return sum
      }
    JS
    
    Crime.collection.map_reduce(map, red,
      :query => { :reported_at => {
          '$lt' => finish, 
          '$gte' => start
        }}, :out => {:inline => true}, :raw => true)
  end
  
  def self.count_of_crimes_in_offense_between(start, finish)
    map = <<-JS 
      function() { 
        var m = this.reported_at.getMonth()
        emit({offense: this.offense_id, month: m, year: this.reported_at.getFullYear()}, 1) 
      } 
    JS
    
    red = <<-JS
      function(key, vals) {
        var sum = 0
        vals.forEach(function(val, idx) {
          sum += val
        })
        
        return sum
      }
    JS
    
    Crime.collection.map_reduce(map, red,
      :query => { :reported_at => {
          '$lt' => finish, 
          '$gte' => start
        }}, :out => "#{start.year}_#{finish.year}_monthly_offense_history")
  end
  
  def self.summaries_for_the_past(start)
    map = <<-JS
    function() {
      var d   = this.reported_at,
          ret = {night: 0, day: 0, business: 0, nightlife: 0}
      
      // Happened during the day
      if(d.getHours() >= 6 && d.getHours() < 18)
        ret.day = 1
      
      // Happened at night
      if(d.getHours() >= 18 || d.getHours() < 6)
        ret.night = 1
      
      // Happened Friday or Saturday night during the hours of 8pm-2am
      if((d.getDay() == 5 || d.getDay() == 6) && (d.getTime() >= 20 || d.getTime() <= 2))
        ret.nightlife = 1
      
      emit(this.offense_id, ret) 
    }
    JS
    
    red = <<-JS
      function(key, vals) {
        var days = 0, nights = 0, business = 0, nightlife = 0
        vals.forEach(function(val) {
            days      += val.day
            nights    += val.night
            business  += val.business
            nightlife += val.nightlife
        })
        return {night: nights, day: days, business: business, nightlife: nightlife}
      }
    JS
    
    Crime.collection.map_reduce(map, red,
      :query => { :reported_at => {
          '$lt' => Time.now, 
          '$gte' => Time.now.change(:hour => 0) - start
        }}, :out => "summaries_for_offenses_in_#{Time.now.year}")
  end
end