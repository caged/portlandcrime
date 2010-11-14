class Neighborhood
  def self.offense_totals_between(from, to = Time.now)
    
    # Build an object with all the offense types
    obj = {}
    offenses = Offense.sort([['type.order', 1], ['order', 1]]).all
    offenses.each do |off|
      obj[off.id.to_s] = 0
    end
    
    map = <<-JS
    function() {
      var obj = #{obj.to_json}
      obj[this.offense_id] = 1
      emit(this.neighborhood_id, obj)
    }
    JS
    
    red = <<-JS
      function(key, group) {
        var obj = #{obj.to_json}
        group.forEach(function(offenses) {
          for(var id in offenses) { 
            obj[id] += offenses[id]
          }
        })
        return obj
      }
    JS
 
    Crime.collection.map_reduce(map, red,
    :query => {:reported_at => {
      '$lt' => to, 
      '$gte' => from.change(:hour => 0)
    }}, :out => "neighborhood_totals_for_#{from.year}")
  end
end