class TrimetRoute
  include MongoMapper::Document  
  
  key :status
  key :type
  key :line
  key :tunnel, Integer
  key :length, Float
  key :geo, Hash
  
  scope :max, :type => 'max', :status => 'existing'
  scope :streetcar, :type => 'street car', :status => 'existing'
  scope :rail, :type.in => ['street car', 'max'], :status => 'existing'
  
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