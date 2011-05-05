class TransitRoute
  include MongoMapper::Document  
  
  key :rte, Integer
  key :prte, Integer
  key :type
  key :desc
  key :dir_desc
  key :dir, Integer
  key :geo, Hash
  
  scope :max_routes,        :type => 'max', :dir => 1
  scope :streetcar_routes,  :type => 'sc'
  scope :bus_routes,        :type => 'bus'
  scope :rail_routes,       :type.in => ['sc', 'max'], :rte.nin => [150]
  
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