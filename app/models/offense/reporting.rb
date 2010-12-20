class Offense
  def self.summaries_for_the_past(start)
    map = <<-JS
    function() {
      var d = this.reported_at
      
      // Happened during the day
      if(d.getHours() >= 6 && d.getHours() < 18) {
        emit(this.offense_id, {night: 0, day: 1, business: 0, nightlife: 0}) 
      }
      
      // Happened at night
      if(d.getHours() >= 18 || d.getHours() < 6) {
        emit(this.offense_id, {night: 1, day: 0, business: 0, nightlife: 0}) 
      }
      
      // Happened Friday or Saturday night during the hours of 8pm-2am
      if((d.getDay() == 5 || d.getDay() == 6) && (d.getTime() >= 20 || d.getTime() <= 2)) {
        emit(this.offense_id, {night: 0, day: 0, business: 0, nightlife: 1}) 
      }
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
      :query => {
        :reported_at => {
          '$lt' => Time.now, 
          '$gte' => Time.now.change(:hour => 0) - start
        }
      }, :out => "summaries_for_offenses_in_#{Time.now.year}")
  end
end

#[{'_id': { oid: '234234234234', period: 'night'}, value:{ }}]