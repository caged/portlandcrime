class Neighborhood
  include MongoMapper::Document 

  key :name
  key :permalink
  key :portland, Boolean, :default => true
  key :geo, Hash
  key :properties, Hash
  
  timestamps!
  
  many :crimes
  many :demographics # For future historical demographics
  
  add_concerns :reporting
  
  scope :portland_only, where(:portland => true)
  
  def to_param
    permalink
  end
  
  def as_geojson(options = {})
    {
      :id => id,
      :geometry => geo,
      :properties => properties.merge(:name => name, :permalink => permalink)
    }
  end
end