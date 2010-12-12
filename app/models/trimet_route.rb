class TrimetRoute
  include MongoMapper::Document  
  
  key :route_number, Integer
  key :public_route_number, Integer
  key :direction, Integer
  key :direction_desc
  key :frequent, Boolean
  key :type
  key :geo, Hash
  
  scope :max_routes, :type => 'max'
  scope :streetcar_routes, :type => 'sc'
  scope :bus_routes, :type => 'bus'
  
  def as_geojson(options = {})
    props = attributes
    props.delete(:loc)
    {
      :id => id.to_s,
      :type => 'Feature',
      :properties => props,
      :geometry => geo
    }
  end
end