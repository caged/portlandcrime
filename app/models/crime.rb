class Crime
  include MongoMapper::Document
  plugin GeoSpatial        
  
  key :case_id, Integer, :required => true
  key :reported_at, Time, :required => true
  key :district, Integer
  key :precinct, String
  key :address, String
  key :loc, Hash, :default => {'lat' => 0, 'lon' => 0}
  key :code, String
  timestamps!
  
  belongs_to :offense      
  belongs_to :neighborhood
  
  add_concerns :reporting
  
  scope :between, lambda {|from, to| where(:reported_at.gte => from, :reported_at.lt => to) }
    
  scope :in_the_past, lambda {|time|   
    where(:reported_at.gte => Time.zone.now.change(:hour => 0) - time, 
          :reported_at.lt => Time.zone.now).sort(:reported_at.desc)}
  
  scope :in_the_year, lambda { |year| year = Time.new(year); between(year, year.end_of_year) }
  
  scope :of_type, lambda {|type| 
    ids = Offense.all(:'type.name' => /#{type}/i).collect(&:id)
    where(:offense_id.in => ids)
  }
  
  # distance (in miles). Defaults to 100 yards
  def self.near_location(loc, distance = 0.0568181818)
    distance = distance / 69.0
    query('loc' => {'$within' => {'$center' => [[loc['lat'], loc['lon']], distance] }})
  end
  
  def as_geojson(options = {})
    props = attributes
    props.delete(:loc)
    {
      :id => id.to_s,
      :type => 'Feature',
      :properties => props,
      :geometry => {
        :type => 'Point', 
        :coordinates => [loc['lat'], loc['lon']]
      }
    }
  end
  
  def at_dark?
    hour = reported_at.hour
    hour >= 18 || hour < 6
  end
  
  def at_daylight?
    hour = reported_at.hour
    hour >= 6 && hour < 18
  end
end