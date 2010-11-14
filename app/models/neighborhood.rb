class Neighborhood
  include MongoMapper::Document 

  key :name
  key :permalink
  key :geo, Hash
  key :properties, Hash
  timestamps!
  
  many :crimes
  
  add_concerns :reporting
  
  def to_param
    permalink
  end
  
  def as_geojson(options = {})
    {
      :id => id,
      :geometry => geo,
      :properties => properties
    }
  end
end