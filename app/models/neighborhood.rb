class Neighborhood
  include MongoMapper::Document         

  key :name
  key :permalink
  timestamps!
  
  many :crimes   
end