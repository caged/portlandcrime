class TransitStop
  @@types = {
    :sc   => %w(sc bsc),
    :max  => %w(max),
    :bus  => %w(bus bsc),
    :rail => %w(sc max bsc)
  }
  
  include MongoMapper::Document
  plugin GeoSpatial
  
  key :stop_id, Integer
  key :name
  key :dir_desc
  key :rte_desc
  key :type
  key :dir, Integer
  key :jurisdiction
  key :zipcode
  key :stop_seq, Integer
  key :frequent, Boolean
  key :loc, Hash, :default => {'lon' => 0, 'lat' => 0}
  key :route_ids, Array
  
  # scope :max_stops, :type => 'max'
  # scope :streetcar_stops, :type.in => %w(sc bsc)
  # scope :bus_stops, :type.in => %w(bus bsc)
  # scope :rail_stops, :type.in => %w(sc max bsc)
  # 
  # many :routes, :in => :route_ids, :class => TransitRoute
  # 
  # def streetcar?
  #   @@types[:sc].include? type
  # end
  # 
  # def max?
  #   @@types[:max].include? type
  # end
  # 
  # def bus?
  #   @@types[:bus].include? type
  # end
  # 
  # def rail?
  #   @@types[:rail].include? type
  # end
  add_concerns :reporting
  
  def as_geojson(options = {})
    props = attributes
    props.delete(:loc)
    {
      :id => id.to_s,
      :type => 'Feature',
      :properties => props,
      :geometry => {
        :type => 'Point', 
        :coordinates => [loc['lon'], loc['lat']]
      }
    }
  end
end