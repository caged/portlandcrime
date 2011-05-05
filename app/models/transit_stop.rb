class TransitStop
  include MongoMapper::Document
  plugin GeoSpatial
  
  key :stop_id, Integer
  key :name
  key :jurisdiction
  key :zipcode
  key :type
  key :loc, Hash, :default => {'lon' => 0, 'lat' => 0}
  
  scope :max_stops, :type => 'max'
  scope :streetcar_stops, :type.in => %w(sc bsc)
  scope :bus_stops, :type.in => %w(bus bsc)
  scope :rail_stops, :type.in => %w(sc max bsc)
  
  # add_concerns :reporting
  
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