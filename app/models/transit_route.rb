class TransitRoute
  include MongoMapper::Document  
  
  key :rte, Integer
  key :prte, Integer
  key :type
  key :desc
  key :dir_desc
  key :dir, Integer
  key :geo, Hash
  key :stop_ids, Array
  
  ensure_index :prte
  
  many :stops, :class => TransitStop, :in => :stop_ids
  
  scope :max_routes,        :type => 'max', :rte.ne => 150, :sort => 'rte'
  scope :streetcar_routes,  :type => 'sc'
  scope :bus_routes,        :type => 'bus', :sort => 'prte'
  # Exclude specialized 150 MAX Mall Shuttle
  scope :rail_routes,       :type.in => ['sc', 'max'], :rte.ne => 150
  
  def name
    "#{desc} #{dir_desc}"
  end
  
  def bus?
    type == 'bus'
  end
  
  def streetcar?
    type == 'sc'
  end
  
  def max?
    type == 'max'
  end
  
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